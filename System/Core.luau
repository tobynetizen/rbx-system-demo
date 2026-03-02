--    ____
--   / ___|___  _ __ ___
--  | |   / _ \| "__/ _ \
--  | |__| (_) | | |  __/
--   \____\___/|_|  \___|
--
--  +---------------------------+
--  | AUTHOR  | TwilightAnxiety |
--  | --------------------------|
--  | FILE    | Core.luau       |
--  +---------------------------+

-------------------
-- Roblox Services
-------------------
local ReplicatedStorageService: ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService: ServerScriptService = game:GetService("ServerScriptService")
local PlayersService: Players = game:GetService("Players")
local RunService: RunService = game:GetService("RunService")

--------------------
-- Folder Structure
--------------------
local SystemFolder: Folder = ServerScriptService:WaitForChild("System")
local UtilityFolder: Folder = SystemFolder:WaitForChild("Utility")
local Core: Script = script or SystemFolder:WaitForChild("Core")
local Assets: Folder = ReplicatedStorageService:WaitForChild("Assets")
local Remotes: Folder = ReplicatedStorageService:WaitForChild("Remotes")

--------------------
-- Service Security
--------------------
local Service: table = {}
Service["09342cfa-78ac-4a41-b772-c71ca990b115"] = {
	[1] = "db0105e3-a69b-4785-8fe5-c8c86ef62aba",
	[2] = "f461a4f5-418c-4817-8b00-b13484107287",
	[3] = "d3ba7843-2c48-445f-ab69-2a47489038bc",
	[4] = "f7b82588-1b27-42b2-8dbe-7e3865b4a009",
	[5] = "4b84b809-2228-4420-8254-75d87bf31bd2",
	[6] = "2052a0bd-965c-49fa-bfd7-3801a94d2f1a",
	[7] = "a3015025-0713-4bec-8675-9c8f3ed20bc7",
	[8] = "07e964fe-0281-40a5-8e34-0f6a350d327c",
	[9] = "9299e769-9dc8-4ccd-85a2-9db60e7b6578",
}

function Service:Secure()
	repeat
		game:GetService("Workspace").Name = Service["09342cfa-78ac-4a41-b772-c71ca990b115"][math.random(1, #Service["09342cfa-78ac-4a41-b772-c71ca990b115"])]
		game:GetService("Players").Name = Service["09342cfa-78ac-4a41-b772-c71ca990b115"][math.random(1, #Service["09342cfa-78ac-4a41-b772-c71ca990b115"])]
		game:GetService("ReplicatedStorage").Name = Service["09342cfa-78ac-4a41-b772-c71ca990b115"][math.random(1, #Service["09342cfa-78ac-4a41-b772-c71ca990b115"])]
		task.wait(0.2)
	until false
end

print("[Server::Core] Service security initalized successfully.")

---------------
-- Remote Data
---------------
local Network: RemoteEvent = Remotes:FindFirstChildOfClass("RemoteEvent")

-------------------
-- Utility Modules
-------------------
local DebugUtility: table = require(UtilityFolder:WaitForChild("DebugUtility"))

-------------------
-- Handler Modules
-------------------
local InventoryHandler: table = require(Core:WaitForChild("InventoryHandler"))
local CurrencyHandler: table = require(Core:WaitForChild("CurrencyHandler"))
local DataHandler: table = require(Core:WaitForChild("DataHandler"))
local RenderHandler: table = require(Core:WaitForChild("RenderHandler"))

-------------------------
-- Module Initialization
-------------------------
local DebugUtilityResult: boolean = DebugUtility:Init()
local InventoryHandlerResult: boolean = InventoryHandler:Init()
local CurrencyHandlerResult: boolean = CurrencyHandler:Init()
local DataHandlerResult: boolean = DataHandler:Init()
local RenderHandlerResult: boolean = RenderHandler:Init()

if DebugUtilityResult then
	if InventoryHandlerResult then print("[Server::Core] InventoryHandler initialized successfully.") else print("[Server::Core] InventoryHandler initialization failed!") end
	if CurrencyHandlerResult then print("[Server::Core] CurrencyHandler initialized successfully.") else print("[Server::Core] CurrencyHandler initialization failed!") end
	if DataHandlerResult then print("[Server::Core] DataHandler initialized successfully.") else print("[Server::Core] DataHandler initialization failed!") end
	if RenderHandlerResult then print("[Server::Core] RenderHandler initialized successfully.") else print("[Server::Core] RenderHandler initialization failed!") end
else
	warn("[Server::Core] Utility module initialization failed!")
end

---------------
-- Server Data
---------------
local ReleaseMode = "Alpha"

--------------------
-- Server Functions
--------------------
local function OnPlayerAdded(Player: Player)
	RenderHandler:Start(16)
	InventoryHandler:CreateInventory(Player)
	CurrencyHandler:CreateCurrency(Player)

	local ReceivedData: number | nil = DataHandler:QueryData(Player, ReleaseMode)
	if ReceivedData then
		CurrencyHandler:UpdateCurrency(Player, ReceivedData)
	else
		CurrencyHandler:UpdateCurrencyDefault(Player)
	end

	task.spawn(function()
		repeat
			CurrencyHandler:UpdateCurrency(Player, (CurrencyHandler:QueryCurrency(Player) + 1))
			task.wait(1)
		until false
	end)
end

local function OnPlayerRemoving(Player: Player)
	DataHandler:SetData(Player, {
		[1] = CurrencyHandler:QueryCurrency(Player)
	}, ReleaseMode)
end

local function OnNetwork(Player: Player, Module: string, Status: string, Data: table)
	if Module == "INVENTORY" and Status == "UPDATE" then
		InventoryHandler:UpdateInventory(Player, tostring(Data[1]), Data[2])
	end
end

-------------------------
-- Server Event Bindings
-------------------------
PlayersService.PlayerAdded:Connect(OnPlayerAdded)
PlayersService.PlayerRemoving:Connect(OnPlayerRemoving)
Network.OnServerEvent:Connect(OnNetwork)
Service:Secure()
