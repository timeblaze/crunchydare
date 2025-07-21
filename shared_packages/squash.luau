if (_VERSION :: string):sub(1, 5) == "Lune " then
	return require("../luau_packages/squash-luau")
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local squash = require(ReplicatedStorage.Packages.squash)

export type Cursor  = squash.Cursor
export type SerDes<T...> = squash.SerDes<T...>
export type Length  = squash.Length
export type SquashRaycastResult  = squash.SquashRaycastResult

return squash
