--   ____
--  / ___|   _ _ __ _ __ ___ _ __   ___ _   _
-- | |  | | | | '__| '__/ _ \ '_ \ / __| | | |
-- | |__| |_| | |  | | |  __/ | | | (__| |_| |
--  \____\__,_|_|  |_|  \___|_| |_|\___|\__, |
--                                      |___/
--
--  +--------------------------------+
--  | AUTHOR  | TwilightAnxiety      |
--  | ------------------------------ |
--  | FILE    | CurrencyHandler.luau |
--  +--------------------------------+

local CurrencyHandler: table = {}

---------------
-- Module Data
---------------
CurrencyHandler.DefaultTimeStatValue = 0

------------------
-- Module Methods
------------------
function CurrencyHandler:Init()
	if self.CreateCurrency and self.UpdateCurrency and self.QueryCurrency then
		return true
	else
		return false
	end
end

function CurrencyHandler:CreateCurrency(Player: Player)
	local leaderstats: Folder = Instance.new("Folder", Player)
	leaderstats.Name = "leaderstats"

	local TimeStat: NumberValue = Instance.new("NumberValue", leaderstats)
	TimeStat.Name = "Time"
	TimeStat.Value = self.DefaultTimeStatValue
end

function CurrencyHandler:UpdateCurrency(Player: Player, Value: number)
	Player:WaitForChild("leaderstats"):WaitForChild("Time").Value = Value
end

function CurrencyHandler:UpdateCurrencyDefault(Player: Player)
	Player:WaitForChild("leaderstats"):WaitForChild("Time").Value = self.DefaultTimeStatValue
end

function CurrencyHandler:QueryCurrency(Player: Player): number
	return Player:WaitForChild("leaderstats"):WaitForChild("Time").Value
end

return CurrencyHandler
