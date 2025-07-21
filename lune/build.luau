local process = require("@lune/process")
local task = require("@lune/task")

local result = process.exec("lune", { "run", "generate" }, {
	stdio = "inherit",
})
if not result.ok then
	process.exit(1)
end

result = process.exec("rojo", { "sourcemap", "-o", "sourcemap.json", "--include-non-scripts" }, {
	stdio = "inherit",
})
if not result.ok then
	process.exit(1)
end

result = process.exec("ovjo", { "build", "-y", "-o", "out" }, {
	stdio = "inherit",
	env = {
		OVJO_LOCALE = "en",
	}
})
if not result.ok then
	process.exit(1)
end

if table.find(process.args, "--edit") or table.find(process.args, "-e") then
	task.spawn(process.exec, "lune", { "run", "ovdr", "studio" }, {
		stdio = "inherit" :: "inherit",
	})
	process.exit(0)
end
