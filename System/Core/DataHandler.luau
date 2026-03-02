--  ____        _
-- |  _ \  __ _| |_ __ _
-- | | | |/ _` | __/ _` |
-- | |_| | (_| | || (_| |
-- |____/ \__,_|\__\__,_|
--
--  +---------------------------+
--  | AUTHOR  | TwilightAnxiety |
--  | ------------------------- |
--  | FILE    | DataHandler.lua |
--  +---------------------------+

local DataHandler: table = {}

-------------------
-- Roblox Services
-------------------
local DataStoreService: DataStoreService = game:GetService("DataStoreService")
local ServerScriptService: ServerScriptService = game:GetService("ServerScriptService")

--------------------
-- Folder Structure
--------------------
local SystemFolder: Folder = ServerScriptService:WaitForChild("System")
local UtilityFolder: Folder = SystemFolder:WaitForChild("Utility")

-------------------
-- Utility Modules
-------------------
local DebugUtility: table = require(UtilityFolder:WaitForChild("DebugUtility"))

---------------
-- Module Data
---------------
local CurrencyDataStoreAlpha: DataStore = DataStoreService:GetDataStore("Alpha-Currency") --> Testing
local CurrencyDataStoreBeta: DataStore = DataStoreService:GetDataStore("Beta-Currency") --> Stable

------------------
-- Module Methods
------------------
function DataHandler:Init()
	if self.SetData and self.QueryData then
		return true
	else
		return false
	end
end

function DataHandler:SetData(Player: Player, Data: table, Mode: string)
	if Data then
		if Mode == "Alpha" then
			local Success, ErrMsg = pcall(function()
				CurrencyDataStoreAlpha:SetAsync("Player-" .. tostring(Player.UserId), Data[1])
			end)

			if not Success then
				DebugUtility:Warn("DataHandler::SetData",
					"Data saving failed for player " .. "[" .. Player.Name .. "] " .. "for datastore " .. "[Alpha]")
			end
		elseif Mode == "Beta" then
			local Success, ErrMsg = pcall(function()
				CurrencyDataStoreBeta:SetAsync("Player-" .. tostring(Player.UserId), Data[1])
			end)

			if not Success then
				DebugUtility:Warn("DataHandler::SetData",
					"Data saving failed for player " .. "[" .. Player.Name .. "] " .. "for datastore " .. "[Beta]")
			end
		else
			DebugUtility:Warn("DataHandler::SetData", "Invalid parameter type specified - String expected")
		end
	else
		DebugUtility:Warn("DataHandler::SetData", "Invalid parameter type specified - Table expected")
	end
end

function DataHandler:QueryData(Player: Player, Mode: string): number
	if Mode == "Alpha" then
		local Success, CurrencyValue = pcall(function()
			return CurrencyDataStoreAlpha:GetAsync("Player-" .. Player.UserId)
		end)

		if Success and CurrencyValue then
			return CurrencyValue
		else
			DebugUtility:Warn("DataHandler::QueryData",
				"Data retrieval failed for player " .. "[" .. Player.Name .. "] " .. "for datastore " .. "[Alpha]")
		end
	elseif Mode == "Beta" then
		local Success, CurrencyValue = pcall(function()
			return CurrencyDataStoreBeta:GetAsync("Player-" .. Player.UserId)
		end)

		if Success and CurrencyValue then
			return CurrencyValue
		else
			DebugUtility:Warn("DataHandler::QueryData",
				"Data retrieval failed for player " .. "[" .. Player.Name .. "] " .. "for datastore " .. "[Beta]")
		end
	end
end

return DataHandler
