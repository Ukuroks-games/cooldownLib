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

	--[[
	
	]]
	counterThread: thread?,
}

--[[
	Cooldown type
]]
export type Cooldown<RetType, ArgsType...> = typeof(setmetatable(
	{} :: CooldownStruct<RetType, ArgsType...>,
	{} :: {
		__index: typeof(cooldown),
		__call: (self: typeof(setmetatable({}, {})), ArgsType...) -> RetType?,
		__tostring: (self: typeof(setmetatable({}, {}))) -> string,
	}
))

--[[
	Destroy
]]
function cooldown.Destroy<RetType, ArgsType...>(self: Cooldown<RetType, ArgsType...>)
	self:StopWatch()
	self.CallEvent:Destroy()
end

--[[
	Call
]]
function cooldown.Call<RetType, ArgsType...>(self: Cooldown<RetType, ArgsType...>, ...: ArgsType...): RetType?
	if self.CanRun == true then
		self.CallEvent:Fire()
		return self.func(...)
	else
		return nil
	end
end

--[[
	Start watch cooldown state
]]
function cooldown.StartWatch<RetType, ArgsType...>(self: Cooldown<RetType, ArgsType...>)
	if not self.counterThread then
		self.counterThread = task.spawn(function()
			while true do
				self.CanRun = true

				self.CallEvent.Event:Wait()

				self.CanRun = false

				task.wait(self.timeout)
			end
		end)
	else
		warn("counterThread already started")
	end
end

--[[
	Stop checking cooldown state.
]]
function cooldown.StopWatch<RetType, ArgsType...>(self: Cooldown<RetType, ArgsType...>)
	if self.counterThread then
		task.cancel(self.counterThread)
	else
		warn("watch don't started yet")
	end
end

--[[
	tostring
]]
function cooldown.tostring<RetType, ArgsType...>(self: Cooldown<RetType, ArgsType...>): string
	return "cooldown:\n 	can run: " .. tostring(self.CanRun) .. "\n	timeout: " .. self.timeout
end

--[[
	Constructor
]]
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
		__tostring = cooldown.tostring :: <RetType, ArgsType...>(self: typeof(setmetatable({}, {}))) -> string,
	})

	self:StartWatch()

	return self
end

return cooldown
