--[[
	CooldownLib
]]
local cooldown = {}

export type Cooldown<ArgsType, RetType> = {
	--[[
		function that wil be called
	]]
	func: (...ArgsType) -> any,

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
	counterThread: thread,

	Call: (self: Cooldown<ArgsType, RetType>, ...ArgsType) -> RetType?,

	Destroy: (self: Cooldown<ArgsType, RetType>) -> nil,
}

function cooldown.Destroy<ArgsType, RetType>(self: Cooldown<ArgsType, RetType>)
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
	local self = {
		CanRun = true,
		timeout = timeout,
		func = func,
		Call = cooldown.Call,
		Destroy = cooldown.Destroy,
		CallEvent = Instance.new("BindableEvent"),
	}

	setmetatable(self, { __call = cooldown.Call })

	return self
end

return cooldown
