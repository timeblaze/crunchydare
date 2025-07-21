local emptyAnimation = Instance.new("Animation")
local character = (script.Parent :: any) :: Model
local humanoid = character:WaitForChild("Humanoid") :: Humanoid
local animator = humanoid:WaitForChild("Animator") :: Animator
local track = animator:LoadAnimation(emptyAnimation)
track:Play()
