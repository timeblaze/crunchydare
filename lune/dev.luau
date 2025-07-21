local pathfs = require("../lune_packages/pathfs")
local process = require("@lune/process")
local serde = require("@lune/serde")

local outDir = pathfs.Directory.fromExisting("out")
local rojoProject: {
	name: string,
} =
	serde.decode("json", pathfs.File.fromExisting("default.project.json"):readFile())

local initialWatching = true
pathfs.watchFile(outDir.path:join(rojoProject.name), function()
	if initialWatching then
		initialWatching = false
		return
	end
	process.exec("ovjo", { "syncback", "-i", outDir.path:toString() }, {
		stdio = "inherit",
		env = {
			OVJO_LOCALE = "en",
		},
	})
end)

process.exec("pesde", { "run", "darklua-build", "--", "--watch" }, {
	stdio = "forward",
})
