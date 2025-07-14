local luaup = require("../luau_packages/luaup")
local pathfs = require("../lune_packages/pathfs")
local process = require("@lune/process")
local fs = pathfs.fs

local DALBIT_POLYFILL_GLOBALS: { [string]: boolean } = {
	unpack = true,
	__DALBIT_getmetatable_iter = true,
	newproxy = true,
	gcinfo = true,
	_VERSION = true,
	bit32 = true,
	buffer = true,
	math = true,
	os = true,
	string = true,
	table = true,
}

local injectedDir = pathfs.Directory.fromExisting("injected")

local visitor = luaup.visit.visitor()
visitor.visit_var = function(state: { injectable: { [string]: boolean } }, node)
	if node.root.kind ~= "name" then
		return
	end
	if state.injectable[node.root.tok.text] == false then
		state.injectable[node.root.tok.text] = true
	end
end

local function getInjectionCodes(): { [string]: string }
	local injectionCodes = {}
	for _, entry in pathfs.getDescendantEntries(injectedDir) do
		if not entry.file or entry.file.path:extension() ~= "luau" then
			continue
		end
		local stem = entry.file.path:fileStem()
		if not stem then
			error("Could not find file stem ")
		end
		local parent = entry.file.path:parent()
		if not parent then
			error("Could not find parent")
		end
		local parentName = parent:fileStem()
		if not parentName then
			error("Could not find parent name")
		end
		injectionCodes[stem] = `local {stem}=require"@injected/{parentName}/{stem}"`
	end
	for name, enabled in DALBIT_POLYFILL_GLOBALS do
		if not enabled then
			continue
		end
		if not injectionCodes[name] then
			injectionCodes[name] = `local {name}=require"@generated/luaPolyfill"["{name}"]`
		end
	end
	return injectionCodes
end

local function inject(input: pathfs.File, output: pathfs.File, injectionCodes: { [string]: string }?)
	local stem = input.path:fileStem()
	if not stem then
		error(`Could not find file stem for {input.path}`)
	end
	-- selene: allow(shadowing)
	local injectionCodes = injectionCodes or getInjectionCodes()
	local code = input:readFile()
	local parsed = luaup.parse(code)
	if not parsed.success then
		error(`{input} {parsed.error.message}`)
	end
	local injectable: { [string]: boolean } = {}
	for name, _ in injectionCodes do
		injectable[name] = false
	end
	local searchState = { injectable = injectable }
	luaup.visit.visit(visitor, searchState, parsed.cst)
	for name, found in searchState.injectable do
		if name == stem then
			-- Do not inject the file itself
			continue
		end
		if not found then
			continue
		end
		local injectionCode = injectionCodes[name]
		code = injectionCode .. code
	end
	pathfs.writeFileAll(output, code)
end

local input = process.args[1]
local output = process.args[2]
if not input or not output then
	print(`{pathfs.script():toString()} Usage: <input> <output>`)
	process.exit(1)
	return
end

if fs.isFile(input) then
	inject(pathfs.File.new(input), pathfs.File.new(output))
	process.exit(0)
	return
end

if fs.isDir(input) then
	local injectionCodes = getInjectionCodes()
	for _, entry in pathfs.getDescendantEntries(input) do
		if not entry.file or entry.file.path:extension() ~= "luau" then
			continue
		end
		local diffed = pathfs.diff(entry.file.path, pathfs.Path.new(input))
		if not diffed then
			continue
		end
		inject(entry.file, pathfs.File.new(pathfs.Path.new(output):join(diffed)), injectionCodes)
	end
	process.exit(0)
	return
end

print("invalid inputs")
process.exit(1)
