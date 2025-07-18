local pathfs = require("../lune_packages/pathfs")
local fs = pathfs.fs
local dirs = require("../lune_packages/dirs")
local process = require("@lune/process")
local roblox = require("@lune/roblox")

-- Generate animations into StringValue-stored animation data
do
	local tempDir = dirs.createTempDir()
	for _, entry in pathfs.getEntries("assets/Animations") do
		if not entry.file then
			continue
		end
		process.exec("anim2rbx", {
			entry.file.path:toString(),
			"--output",
			tempDir.path:join(entry.file.path:fileStem() :: string):withExtension("rbxm"):toString(),
		}, {
			stdio = "inherit",
		})
	end
	for _, entry in pathfs.getEntries(tempDir) do
		if not entry.file then
			continue
		end
		local valuePath =
			pathfs.Path.new("generated"):join("Animations"):join(entry.file.path:fileStem() :: string):withExtension("rbxm")
		if not fs.isDir(valuePath:parent() :: pathfs.Path) then
			fs.writeDir(valuePath:parent() :: pathfs.Path)
		end
		fs.writeFile(valuePath, entry.file:readFile())
	end
end
