--!strict
--!optimize 2
--!native
-- Fakes KeyframeSequence class for Crunchyroll's Roblox asset.
-- This code is for OVERDARE and Lune.
-- faked KeyframeSequence with lua table and serialized via custom format made with Squash.

local squash = require("../../shared_packages/squash")

local CFrame = CFrame
local Vector3 = Vector3
if (_VERSION :: string):sub(1, 5) == "Lune " then
	local roblox = require("@lune/roblox")
	CFrame = (roblox :: any).CFrame
	Vector3 = (roblox :: any).Vector3
end

local T = squash.T

type InternalKeyframeSequence = typeof(setmetatable(
	{} :: {
		keyframes: { Keyframe },
	},
	{} :: KeyframeSequenceImpl
)) & KeyframeSequence

-- Only implements the methods we need for Crunchyroll's Roblox asset.
type KeyframeSequenceImpl = {
	__index: KeyframeSequenceImpl,
	new: (keyframes: { Keyframe }?) -> KeyframeSequence,
	serializer: squash.SerDes<KeyframeSequence>,
	GetKeyframes: (self: InternalKeyframeSequence) -> { Keyframe },
}

local KeyframeSequence = {} :: KeyframeSequenceImpl
KeyframeSequence.__index = KeyframeSequence

function KeyframeSequence.new(keyframes)
	return setmetatable({
		keyframes = keyframes or {},
	}, KeyframeSequence) :: any
end

function KeyframeSequence:GetKeyframes()
	return self.keyframes
end

local vectorSerializer: squash.SerDes<vector> = {
	ser = function(cursor, data)
		squash.tryrealloc(cursor, 12)
		local buf = cursor.Buf
		local pos = cursor.Pos

		buffer.writef32(buf, pos, data.z)
		pos += 4
		buffer.writef32(buf, pos, data.y)
		pos += 4
		buffer.writef32(buf, pos, data.x)
		pos += 4

		cursor.Pos = pos
	end,
	des = function(cursor)
		local buf = cursor.Buf
		local pos = cursor.Pos

		pos -= 4
		local x = buffer.readf32(buf, pos)
		pos -= 4
		local y = buffer.readf32(buf, pos)
		pos -= 4
		local z = buffer.readf32(buf, pos)
		cursor.Pos = pos

		return vector.create(x, y, z)
	end,
}

do
	local poseNodeSerializer = squash.record({
		nameIndex = T(squash.int(1)),
		matrix = T(squash.record({
			pos = T(vectorSerializer),
			vX = T(vectorSerializer),
			vY = T(vectorSerializer),
			vZ = T(vectorSerializer),
		})),
	})

	local keyframeNodeSerializer = squash.record({
		time = T(squash.number(4)),
		poseNodes = T(squash.array(poseNodeSerializer)),
	})

	local serializedFormatSerializer = squash.record({
		nameMap = T(squash.array(squash.string())),
		keyframeNodes = T(squash.array(keyframeNodeSerializer)),
	})

	local function vectorFromVector3(vec3: Vector3)
		return vector.create(vec3.X, vec3.Y, vec3.Z)
	end

	local function vectorToVector3(v: vector)
		return Vector3.new(v.x, v.y, v.z)
	end

	local function createPose(name: string, cframe: CFrame): Pose
		return {
			Name = name,
			CFrame = cframe,
			GetSubPoses = function()
				return {}
			end,
		} :: any
	end

	local function createKeyframe(time: number, poses: { Pose }): Keyframe
		return {
			Time = time,
			GetPoses = function()
				return poses
			end,
			GetMarkers = function()
				return {}
			end,
		} :: any
	end

	KeyframeSequence.serializer = {
		ser = function(cursor, data)
			local nextNameIndex = 1
			local nameIndexMap: { [string]: number } = {}

			local function recursiveCollectPoseNode(rootPose: Pose, poseNodes: { typeof(T(poseNodeSerializer)) })
				local cframe = rootPose.CFrame
				local nameIndex = nameIndexMap[rootPose.Name]
				if not nameIndex then
					nameIndex = nextNameIndex
					nameIndexMap[rootPose.Name] = nameIndex
					nextNameIndex += 1
				end
				poseNodes[#poseNodes + 1] = {
					nameIndex = nameIndex,
					matrix = {
						pos = vectorFromVector3(cframe.Position),
						vX = vectorFromVector3(cframe.XVector),
						vY = vectorFromVector3(cframe.YVector),
						vZ = vectorFromVector3(cframe.ZVector),
					},
				}

				for _, subPose in rootPose:GetSubPoses() do
					if not subPose:IsA("Pose") then
						continue
					end
					recursiveCollectPoseNode(subPose, poseNodes)
				end
			end

			local keyframeNodes: { typeof(T(keyframeNodeSerializer)) } = {}
			for _, keyframe in data:GetKeyframes() do
				if not keyframe:IsA("Keyframe") then
					continue
				end

				local poseNodes: { typeof(T(poseNodeSerializer)) } = {}
				for _, pose in keyframe:GetPoses() do
					if not pose:IsA("Pose") then
						continue
					end
					recursiveCollectPoseNode(pose, poseNodes)
				end

				keyframeNodes[#keyframeNodes + 1] = {
					time = keyframe.Time,
					poseNodes = poseNodes,
				}
			end

			local nameMap: { string } = {}
			for name, index in nameIndexMap do
				nameMap[index] = name
			end

			serializedFormatSerializer.ser(cursor, {
				nameMap = nameMap,
				keyframeNodes = keyframeNodes,
			})
		end,
		des = function(cursor)
			local deserialized = serializedFormatSerializer.des(cursor)

			local keyframes: { Keyframe } = {}
			for _, keyframeNode in deserialized.keyframeNodes do
				local poses: { Pose } = {}
				for _, poseNode in keyframeNode.poseNodes do
					local vX = poseNode.matrix.vX
					local vY = poseNode.matrix.vY
					local vZ = poseNode.matrix.vZ
					local pos = poseNode.matrix.pos
					local cf = if (_VERSION :: string):sub(1, 5) == "Lune "
						then CFrame.fromMatrix(
							vectorToVector3(poseNode.matrix.pos),
							vectorToVector3(poseNode.matrix.vX),
							vectorToVector3(poseNode.matrix.vY),
							vectorToVector3(poseNode.matrix.vZ)
						)
						else
							-- CFrame.fromMatrix(
							-- 	vectorToVector3(poseNode.matrix.pos),
							-- 	vectorToVector3(poseNode.matrix.vX) * -1,
							-- 	vectorToVector3(poseNode.matrix.vY),
							-- 	vectorToVector3(poseNode.matrix.vZ) * -1
							-- )
							CFrame.fromMatrix(
								Vector3.new(-pos.y, -pos.z, pos.x),
								Vector3.new(vY.y, vZ.y, -vX.y),
								Vector3.new(vY.z, vZ.z, -vX.z),
								Vector3.new(-vY.x, -vZ.x, vX.x)
							)
					-- PosX=-PosY
					-- PosY=-PosZ
					-- PosZ=PosX
					-- RightX=UpY
					-- RightY=LookY
					-- RightZ=-RightY
					-- UpX=UpZ
					-- UpY=LookZ
					-- UpZ=-RightZ
					-- LookX=-UpX
					-- LookY=-LookX
					-- LookZ=RightX
					print(cf)
					poses[#poses + 1] = createPose(deserialized.nameMap[poseNode.nameIndex], cf)
				end
				keyframes[#keyframes + 1] = createKeyframe(keyframeNode.time, poses)
			end

			return KeyframeSequence.new(keyframes)
		end,
	}
end

return KeyframeSequence
