local CODEGEN_RIG = true

local character = (script.Parent :: any) :: Model

if CODEGEN_RIG then
	local function recursiveCollectCodegenRig(bone: Bone): string
		local cfPos = bone.CFrame.Position
		local vX, vY, vZ = bone.CFrame.XVector, bone.CFrame.YVector, bone.CFrame.ZVector
		local fields: { string } = {
			`name = "{bone.Name}"`,
			`c0 = CFrame.fromMatrix(Vector3.new({cfPos.X}, {cfPos.Y}, {cfPos.Z}), Vector3.new({vX.X}, {vX.Y}, {vX.Z}), Vector3.new({vY.X}, {vY.Y}, {vY.Z}), Vector3.new({vZ.X}, {vZ.Y}, {vZ.Z}))`,
			`c1 = CFrame.identity`,
		}
		local children: { string } = {}
		for _, child in bone:GetChildren() do
			if not child:IsA("Bone") then
				continue
			end
			children[#children + 1] = recursiveCollectCodegenRig(child)
		end
		fields[#fields + 1] = `children = \{{table.concat(children, ",\n")}\}`
		return `\{{table.concat(fields, ",\n")}\}`
	end
	local code = recursiveCollectCodegenRig(character:WaitForChild("Skeleton"):WaitForChild("Root") :: Bone)
	print(code)
end
