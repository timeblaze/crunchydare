local emptyAnimation = Instance.new("Animation")
local humanoid = ((script.Parent :: any) :: Model):WaitForChild("Humanoid") :: Humanoid
local animator = humanoid:WaitForChild("Animator") :: Animator
local track = animator:LoadAnimation(emptyAnimation)
track:Play()
