local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")
		if not humanoid:IsA("Humanoid") then
			return
		end
		humanoid.WalkSpeed = 1000
		humanoid.JumpPower = 1000
	end)
end)
