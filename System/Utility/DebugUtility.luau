--  ____       _
-- |  _ \  ___| |__  _   _  __ _
-- | | | |/ _ \ '_ \| | | |/ _` |
-- | |_| |  __/ |_) | |_| | (_| |
-- |____/ \___|_.__/ \__,_|\__, |
--                         |___/
--
--  +-----------------------------+
--  | AUTHOR  | TwilightAnxiety   |
--  | --------------------------- |
--  | FILE    | DebugUtility.luau |
--  +-----------------------------+

local DebugUtility: table = {}

---------------
-- Module Data
---------------
local LogCount: number = 0
local WarnCount: number = 0
local ErrorCount: nunmber = 0
local LastCallEnv: string = "N/A"

------------------
-- Module Methods
------------------
function DebugUtility:Init(): boolean
	if self.Log and self.Warn and self.Error and self.GetLogCount and self.GetWarnCount and self.GetErrorCount and self.GetLastCallEnv then
		return true
	else
		return false
	end
end

function DebugUtility:Log(Environment: string, Message: string)
	LogCount = LogCount + 1
	LastCallEnv = Environment
	print("[" .. Environment .. "] " .. Message)
end

function DebugUtility:Warn(Environment: string, Message: string)
	WarnCount = WarnCount + 1
	LastCallEnv = Environment
	warn("[" .. Environment .. "] " .. Message)
end

function DebugUtility:Error(Environment: string, Message: string)
	ErrorCount = ErrorCount + 1
	LastCallEnv = Environment
	error("[" .. Environment .. "] " .. Message)
end

function DebugUtility:GetLogCount(): number
	return LogCount
end

function DebugUtility:GetWarnCount(): number
	return WarnCount
end

function DebugUtility:GetErrorCount(): number
	return ErrorCount
end

function DebugUtility:GetLastCallEnv(): string
	return LastCallEnv
end

return DebugUtility
