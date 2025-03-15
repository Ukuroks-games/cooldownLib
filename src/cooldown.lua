local cooldown = {}

export type Cooldown<ArgsType, RetType> = {
	func: (... ArgsType) -> any,
	CanRun: boolean,
	timeout: number,
	CallEvent: BindableEvent,
	counterThread: thread,

	Call: (self: Cooldown<ArgsType, RetType>, ... ArgsType) -> RetType?,
	__call: (self: Cooldown<ArgsType, RetType>, ... ArgsType) -> RetType?,
	Destroy: (self: Cooldown<ArgsType, RetType>) -> nil
}

function cooldown.Destroy<ArgsType, RetType>(self: Cooldown<ArgsType, RetType>)
	task.cancel(self.counterThread)
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

function cooldown.new<ArgsType, RetType>(timeout: number, func: (... ArgsType) -> RetType): Cooldown<ArgsType, RetType>

	local self: Cooldown<ArgsType, RetType> 
	
	self = {
		CanRun = true,
		timeout = timeout,
		func = func,
		Call = cooldown.Call,
		__call =  cooldown.Call,
		Destroy = cooldown.Destroy,
		CallEvent = Instance.new("BindableEvent")
	}
	
	self.counterThread = task.spawn(function()			
		while true do
			self.CanRun = true
			self.CallEvent.Event:Wait()
			self.CanRun = false
			wait(self.timeout)
		end
	end)

	return self
end

return cooldown
