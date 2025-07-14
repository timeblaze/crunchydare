local dirs = require("../lune_packages/dirs")
local pathfs = require("../lune_packages/pathfs")
local process = require("@lune/process")
local serde = require("@lune/serde")

local tempDir = dirs.createTempDir()
local dummyLuauFile = pathfs.File.create(tempDir.path:join("dummy.luau"), "")
local dalbitManifest = {
	input = dummyLuauFile.path:fileName(),
	output = "output.lua",
	target_version = "lua53",
	minify = false,
	modifiers = {},
	polyfill = {
		repository = "https://github.com/CavefulGames/dalbit-polyfill",
		injection_path = "polyfill",
	},
}
local dalbitToml = pathfs.File.create(tempDir.path:join("dalbit.toml"), serde.encode("toml", dalbitManifest))

process.exec("dalbit", {
	"transpile",
	"--config",
	dalbitToml.path:toString(),
}, {
	stdio = "inherit",
})

local injectedPolyfillFile = pathfs.File.fromExisting(tempDir.path:join(`{dalbitManifest.polyfill.injection_path}.lua`))
pathfs.writeFileAll("generated/luaPolyfill.luau", injectedPolyfillFile:readFile())
tempDir:removeDir()
