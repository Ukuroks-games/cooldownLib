--!strict

--[[
	CooldownLib
]]
local cooldown = {}

type CooldownStruct<ArgsType, RetType> = {
	--[[
		function that wil be called
	]]
	func: (...ArgsType) -> RetType,

	--[[
		Can run function right now
	]]
	CanRun: boolean,

	--[[
		cooldown time
	]]
	timeout: number,

	--[[
		
	]]
	CallEvent: BindableEvent,
	counterThread: thread?,
}

export type Cooldown<ArgsType, RetType> = typeof(setmetatable({} :: CooldownStruct<ArgsType, RetType>, {
	__index = cooldown,
	__call = function(self: typeof(setmetatable({}, {})), ...: ArgsType): RetType? -- просто заглушка
		return nil
	end,
}))

function cooldown.Destroy<ArgsType, RetType>(self: Cooldown<ArgsType, RetType> & {})
	self.CallEvent:Destroy()
	table.clear(self)
end

function cooldown.Call<ArgsType, RetType>(self: Cooldown<ArgsType, RetType>, ...: ArgsType): RetType?
	if self.CanRun == true then
		self.CallEvent:Fire()
		return self.func(...)
	else
		return nil
	end
end

function cooldown.new<ArgsType, RetType>(timeout: number, func: (...ArgsType) -> RetType): Cooldown<ArgsType, RetType>
	local self: CooldownStruct<ArgsType, RetType> = {
		CanRun = true,
		timeout = timeout,
		func = func,
		CallEvent = Instance.new("BindableEvent"),
	}

	setmetatable(self, {
		__index = cooldown,
		__call = cooldown.Call :: <ArgsType, RetType>(self: typeof(setmetatable({}, {})), ...ArgsType) -> RetType?,
	})

	return self
end

return cooldown
