local pathfs = require("../lune_packages/pathfs")
local fs = pathfs.fs
local KeyframeSequence = require("../src/ReplicatedStorage/KeyframeSequence")
local base91 = require("../luau_packages/base91-luau")
local dirs = require("../lune_packages/dirs")
local process = require("@lune/process")
local roblox = require("@lune/roblox")
local squash = require("../shared_packages/squash")

-- Generate animations into StringValue-stored animation data
do
	local tempDir = dirs.createTempDir()
	local ok, errOrValue = pcall(function()
		roblox.implementMethod("KeyframeSequence", "GetKeyframes", function(instance)
			return instance:GetChildren()
		end)
		roblox.implementMethod("Keyframe", "GetPoses", function(instance)
			return instance:GetChildren()
		end)
		roblox.implementMethod("Pose", "GetSubPoses", function(instance)
			return instance:GetChildren()
		end)

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
			local valuePath = pathfs.Path
				.new("generated")
				:join("Animations")
				:join(entry.file.path:fileStem() :: string)
				:withExtension("rbxm")
			if not fs.isDir(valuePath:parent() :: pathfs.Path) then
				fs.writeDir(valuePath:parent() :: pathfs.Path)
			end
			local kfs = (roblox.deserializeModel(entry.file:readFile())[1] :: any) :: KeyframeSequence?
			if not kfs or not kfs:IsA("KeyframeSequence") then
				continue
			end
			local cursor = squash.cursor(64)
			KeyframeSequence.serializer.ser(cursor, kfs)
			local stringValue = roblox.Instance.new("StringValue") :: StringValue
			stringValue.Value = buffer.tostring(base91.encodeBuffer(squash.tobuffer(cursor)))
			fs.writeFile(valuePath, roblox.serializeModel({ stringValue :: any }))

			local c = squash.frombuffer(squash.tobuffer(cursor))
			local kfs = KeyframeSequence.serializer.des(c)
		end
	end)
	if tempDir:isDir() then
		tempDir:removeDir()
	end
	if not ok then
		error("Failed to generate animations: " .. tostring(errOrValue))
	end
end
