--   ___       _             __
--  |_ _|_ __ | |_ ___ _ __ / _| __ _  ___ ___
--   | || "_ \| __/ _ \ "__| |_ / _` |/ __/ _ \
--   | || | | | ||  __/ |  |  _| (_| | (_|  __/
--  |___|_| |_|\__\___|_|  |_|  \__,_|\___\___|
--
--  +---------------------------+
--  | AUTHOR  | TwilightAnxiety |
--  | ------------------------- |
--  | FILE    | Interface.luau  |
--  +---------------------------+

-------------------
-- Roblox Services
-------------------
print("[Client::Interface] Initializing services...")
local ReplicatedStorageService: ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService: RunService = game:GetService("RunService")
local PlayersService: Players = game:GetService("Players")
local UserInputService: UserInputService = game:GetService('UserInputService')

--------------------
-- Folder Structure
--------------------
local Remotes: Folder = ReplicatedStorageService:WaitForChild("Remotes")
local Assets: Folder = ReplicatedStorageService:WaitForChild("Assets")

-------------------
-- Client Security
-------------------
print("[Client::Interface] Initializing remote network security...")
local Network: table = {}
Network["ec47b8af-3deb-4442-93b5-92bc27832386"] = Remotes:FindFirstChildOfClass("RemoteFunction")
Network["499576f0-6688-49fa-a34a-9481541f458a"] = Remotes:FindFirstChildOfClass("RemoteEvent")
Network["09342cfa-78ac-4a41-b772-c71ca990b115"] = {
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

function Network:FireServer(Remote: RemoveEvent | string, ...)
	Remote:FireServer(...)
end

function Network:InvokeServer(Remote: RemoteFunction | string, ...): any
	return Remote:InvokeServer(...)
end

function Network:Secure()
	repeat
		pcall(function()
			Network["ec47b8af-3deb-4442-93b5-92bc27832386"].Name = Network["09342cfa-78ac-4a41-b772-c71ca990b115"][math.random(1, #Network["09342cfa-78ac-4a41-b772-c71ca990b115"])]
			Network["499576f0-6688-49fa-a34a-9481541f458a"].Name = Network["09342cfa-78ac-4a41-b772-c71ca990b115"][math.random(1, #Network["09342cfa-78ac-4a41-b772-c71ca990b115"])]
			Network:FireServer(Network["09342cfa-78ac-4a41-b772-c71ca990b115"][math.random(1, #Network["09342cfa-78ac-4a41-b772-c71ca990b115"])])
			Network:InvokeServer(Network["09342cfa-78ac-4a41-b772-c71ca990b115"][math.random(1, #Network["09342cfa-78ac-4a41-b772-c71ca990b115"])])
		end)
		task.wait(0.2)
	until false
end

---------------
-- Client Data
---------------
print("[Client::Interface] Initializing client data...")
local Player: Player = PlayersService.LocalPlayer
local Character: Model = Player.Character or Player.CharacterAdded:Wait()
local Mouse: PlayerMouse = Player:GetMouse()
local LookControlBlock: boolean = false
local PlayerInventoryUI: ScreenGui = Player:WaitForChild("PlayerGui"):WaitForChild("InventoryUI")
local PlayerBackpackFrame: Frame = PlayerInventoryUI:WaitForChild("BackpackFrame")
local PlayerBackpackButtonFrame: Frame = PlayerInventoryUI:WaitForChild("BackpackButtonFrame")
local PlayerBackpackButton: ImageButton = PlayerBackpackButtonFrame:WaitForChild("BackpackButton")
local SlotsFolder: Folder = PlayerBackpackFrame:WaitForChild("Slots")

--------------------
-- Client Functions
--------------------
local function OnRenderStep()
	pcall(function()
		if Mouse.Hit ~= nil then
			if Mouse.Target.Parent.Name == "Map" then
				LookControlBlock = true
			else
				LookControlBlock = false
			end
		else
			LookControlBlock = false
		end
	end)
end

local function OnInputBegan(Input, GameProcessed)
	if not GameProcessed then
		if Input.UserInputType == Enum.UserInputType.MouseButton1 then
			if LookControlBlock then
				Network:FireServer(Network["499576f0-6688-49fa-a34a-9481541f458a"], "INVENTORY", "UPDATE", {
					[1] = Mouse.Target.BrickColor,
					[2] = Mouse.Target
				})
			end
		end
	end
end

local function OnBackpackButtonClick()
	PlayerBackpackFrame.Visible = not PlayerBackpackFrame.Visible
end

-------------------------
-- Client Event Bindings
-------------------------
print("[Client::Interface] Initializing event bindings...")
RunService:BindToRenderStep("010ba515-b564-438a-ad3b-8ccd5eb7c4ad", Enum.RenderPriority.Input.Value, OnRenderStep)
UserInputService.InputBegan:Connect(OnInputBegan)
PlayerBackpackButton.MouseButton1Click:Connect(OnBackpackButtonClick)
Network:Secure()

task.delay(1, function()
	print("[Client::Interface] Client initialized successfully.")
end)
