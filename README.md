[![Lint](https://github.com/Ukuroks-games/cooldownLib/actions/workflows/Lint.yaml/badge.svg)](https://github.com/Ukuroks-games/cooldownLib/actions/workflows/Lint.yaml)

# CooldownLib

Just small library for creating cooldown.

## Example

Print `call` every 2 second

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cooldown = require(ReplicatedStorage.Packages.cooldown)

local c = cooldown.new(
	2,
	function() 
		print("call")
		return true
 	end
)

while task.wait() do
	c()
end

```
