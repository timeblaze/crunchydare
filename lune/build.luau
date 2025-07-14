local pathfs = require("../lune_packages/pathfs")
local process = require("@lune/process")
local fs = pathfs.fs
local serde = require("@lune/serde")
local stdio = require("@lune/stdio")
local task = require("@lune/task")

local SOURCE_SYNCING_PROJECT = "default.project.json"
local OUT_SOURCE_PATH = pathfs.Path.new("out"):join("source")
local OUT_WORLD_PATH = pathfs.Path.new("out"):join("world")
local BUILD_PROJECT_NAME = "build"
local ERROR_PREFIX = `{stdio.color("red")}{stdio.style("bold")}error{stdio.color("reset")}:`
local SOURCEMAP_PATH = "sourcemap.json"

local function run(command, params)
	print(command, params)
	local result = process.exec(command, params, { stdio = "inherit" })
	if not result.ok then
		print(`{ERROR_PREFIX} {result.stderr}`)
		process.exit(1)
		error("unreachable")
	end
end

local function buildSource()
	fs.writeDir(OUT_SOURCE_PATH:parent() :: pathfs.Path)
	local project = serde.decode("json", fs.readFile(SOURCE_SYNCING_PROJECT))
	local function visitForPath(paths: { string }, current: any)
		local path = current["$path"]
		if path then
			table.insert(paths, path)
		end
		for _, v in current do
			if type(v) == "table" then
				visitForPath(paths, v)
			end
		end
	end
	local paths = {}
	visitForPath(paths, project)
	for _, p in paths do
		fs.copy(p, OUT_SOURCE_PATH:join(p), true)
	end

	fs.copy(SOURCE_SYNCING_PROJECT, OUT_SOURCE_PATH:join("default.project.json"), true)

	fs.copy(".darklua.json5", OUT_SOURCE_PATH:join(".darklua.json5"), true)
	fs.copy(".luaurc", OUT_SOURCE_PATH:join(".luaurc"), true)
	run("rojo", { "sourcemap", "build.project.json", "-o", OUT_SOURCE_PATH:join("sourcemap.json"):toString() })
	-- TO-DO: dalbit removes types and darklua doesn't remove types (but why currently darklua remove instead? -> dalbit errors with like '>>' because of non-specified lua version with its darklua/full_moon dependency)
	for _, ent in pathfs.getEntries(OUT_SOURCE_PATH) do
		if not ent.dir or ent.name == "generated" then
			continue
		end
		print(ent.name)
		local result = process.exec(
			"darklua",
			{ "process", ent.name, ent.name },
			{ stdio = "inherit", cwd = OUT_SOURCE_PATH:toString() }
		)
		if not result.ok then
			error(result.stderr)
		end
	end
	run("dalbit", { "transpile" })
	for _, ent in pathfs.getEntries(OUT_SOURCE_PATH) do
		if not ent.dir or ent.name == "generated" then
			continue
		end
		run("lune", { "run", "inject", ent.dir.path:toString(), ent.dir.path:toString() })
	end
	-- dalbit creates another path require so need to run darklua again
	run("rojo", {
		"sourcemap",
		OUT_SOURCE_PATH:join("default.project.json"):toString(),
		"-o",
		OUT_SOURCE_PATH:join("sourcemap.json"):toString(),
	})
	for _, ent in pathfs.getEntries(OUT_SOURCE_PATH) do
		if not ent.dir or ent.name == "generated" then
			continue
		end
		print(ent.name)
		local result = process.exec(
			"darklua",
			{ "process", ent.name, ent.name },
			{ stdio = "inherit", cwd = OUT_SOURCE_PATH:toString() }
		)
		if not result.ok then
			error(result.stderr)
		end
	end
	-- fs.copy(SOURCE_SYNCING_PROJECT, OUT_SOURCE_PATH:join("default.project.json"), true)

	-- dalbit transpile again for convert_bit32? (not yet idk)
end

local function buildWorld()
	local result = process.exec(
		"ovjo",
		{ "build", BUILD_PROJECT_NAME, "-o", OUT_WORLD_PATH:toString(), "-y" },
		{ stdio = "inherit" }
	)
	if not result.ok then
		error(result.stderr)
	end
end

local function syncSource()
	local projectFile = pathfs.File.fromExisting(BUILD_PROJECT_NAME .. ".project.json")
	local project = serde.decode("json", projectFile:readFile())
	local result = process.exec("ovjo", {
		"sync",
		"-i",
		pathfs.Path
			.new("../")
			:join(OUT_WORLD_PATH:fileStem() :: string)
			:join(project.name)
			:withExtension("umap")
			:toString(),
	}, { stdio = "inherit", cwd = OUT_SOURCE_PATH:toString() })
	if not result.ok then
		error(result.stderr)
	end
end

local optSync = table.find(process.args, "--sync") or table.find(process.args, "-s")
if optSync then
	buildSource()
	syncSource()
	print("Source synced successfully!")
else
	buildSource()
	buildWorld()
	syncSource()
	print("Build completed successfully!")
end

local function watchFile(fileName: string, callback: () -> ())
	local t
	t = task.spawn(function()
		local lastModified = fs.metadata(fileName).modifiedAt
		while true do
			local metadata = fs.metadata(fileName)
			if not metadata.exists then
				if coroutine.status(t) ~= "running" then
					coroutine.close(t)
				end
				return
			end
			local newModified = metadata.modifiedAt
			if newModified ~= lastModified then
				task.spawn(callback)
				lastModified = newModified
			end
			task.wait(1)
		end
	end)
	return t
end

if table.find(process.args, "--edit") or table.find(process.args, "-e") then
	if not optSync then
		task.spawn(run, "lune", { "run", "ovdr", "studio" })
		print("Please open the built world in OVDR Studio to edit.")
	end

	local projectFile = pathfs.File.fromExisting(BUILD_PROJECT_NAME .. ".project.json")
	local project = serde.decode("json", projectFile:readFile())
	watchFile(OUT_WORLD_PATH:join(project.name):withExtension("umap"):toString(), function()
		run("ovjo", { "syncback", "build", "-i", "out/world" })
	end)

	local sourcemapWatchingPathsThreads: { thread } = {}
	local function watchSourcemapLuaFiles(children: {
		{
			children: {},
			filePaths: { string },
		}
	})
		for _, child in children do
			if child.filePaths then
				for _, filePath in child.filePaths do
					local ext = pathfs.Path.new(filePath):extension()
					if ext ~= "luau" and ext ~= "lua" then
						continue
					end
					table.insert(
						sourcemapWatchingPathsThreads,
						watchFile(filePath, function()
							buildSource()
							syncSource()
						end)
					)
				end
			end
			if child.children then
				watchSourcemapLuaFiles(child.children)
			end
		end
	end

	pathfs.watchFile(SOURCEMAP_PATH, function()
		for _, thread in sourcemapWatchingPathsThreads do
			coroutine.close(thread)
		end
		local sourcemap = serde.decode("json", fs.readFile(SOURCEMAP_PATH))
		watchSourcemapLuaFiles(sourcemap.children)
	end)
	run("rojo", { "sourcemap", "--watch", "-o", SOURCEMAP_PATH, "--include-non-scripts" })
end
