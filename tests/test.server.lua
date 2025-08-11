--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cooldown = require(ReplicatedStorage.Packages.cooldownlib)

local c = cooldown.new(2, function()
	print("call")
	return true
end)

while task.wait(0.5) do
	if not c() then
		print("can't call")
	end
end
