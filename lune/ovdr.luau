-- Delete this after https://github.com/rojo-rbx/rokit/issues/22 got solved

local process = require("@lune/process")
local task = require("@lune/task")

local arg = process.args[1]

if not arg then
	process.exec("ovjo", { "ovdr", "--help" }, { stdio = "forward" })
	process.exit(1)
	return
end

local function trim(s: string): string
	return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function getResultFromOvjoOvdr(ovdrCommand: string)
	local result = process.exec("ovjo", { "ovdr", ovdrCommand, "--dry-run" })
	if not result.ok then
		error(result.stderr)
	end
	return trim(result.stdout)
end

local commands = {
	studio = function()
		task.spawn(process.exec, getResultFromOvjoOvdr("studio"))
	end,
	docs = function()
		local url = getResultFromOvjoOvdr("docs")
		if process.args[2] then
			url = url .. "?q=" .. process.args[2]
		end
		process.exec("start", { url }, { shell = true })
	end,
	creator = function()
		process.exec("start", { getResultFromOvjoOvdr("creator") }, { shell = true })
	end,
	forum = function()
		process.exec("start", { getResultFromOvjoOvdr("forum") }, { shell = true })
	end,
}

local action = commands[arg]
if action then
	action()
	process.exit(0)
	return
end

print(`Command \`{arg}\` not found`)
process.exit(1)
