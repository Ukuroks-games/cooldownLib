--!strict

--[[
	CooldownLib
]]
local cooldown = {}

type CooldownStruct<RetType, ArgsType...> = {
	--[[
		function that wil be called
	]]
	func: (ArgsType...) -> RetType,

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

export type Cooldown<RetType, ArgsType...> = typeof(setmetatable({} :: CooldownStruct<RetType, ArgsType...>, {
	__index = cooldown,
	__call = function(self: typeof(setmetatable({}, {})), ...: ArgsType...): RetType? -- просто заглушка
		return nil
	end,
}))

function cooldown.Destroy<ArgsType, RetType>(self: Cooldown<ArgsType, RetType> & {})
	self.CallEvent:Destroy()
	table.clear(self)
end

function cooldown.Call<RetType, ArgsType...>(self: Cooldown<RetType, ArgsType...>, ...: ArgsType...): RetType?
	if self.CanRun == true then
		self.CallEvent:Fire()
		return self.func(...)
	else
		return nil
	end
end

function cooldown.new<RetType, ArgsType...>(timeout: number, func: (ArgsType...) -> RetType): Cooldown<RetType, ArgsType...>
	local self: CooldownStruct<RetType, ArgsType...> = {
		CanRun = true,
		timeout = timeout,
		func = func,
		CallEvent = Instance.new("BindableEvent"),
	}

	setmetatable(self, {
		__index = cooldown,
		__call = cooldown.Call :: <RetType, ArgsType...>(self: typeof(setmetatable({}, {})), ArgsType...) -> RetType?,
	})

	return self
end

return cooldown
