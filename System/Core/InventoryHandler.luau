--  ___                      _
-- |_ _|_ ____   _____ _ __ | |_ ___  _ __ _   _
--  | || '_ \ \ / / _ \ '_ \| __/ _ \| '__| | | |
--  | || | | \ V /  __/ | | | || (_) | |  | |_| |
-- |___|_| |_|\_/ \___|_| |_|\__\___/|_|   \__, |
--                                         |___/
--
--  +---------------------------------+
--  | AUTHOR  | TwilightAnxiety       |
--  | ------------------------------- |
--  | FILE    | InventoryHandler.luau |
--  +---------------------------------+

local InventoryHandler: table = {}

-------------------
-- Roblox Services
-------------------
local ServerScriptService: ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorageService: ReplicatedStorage = game:GetService("ReplicatedStorage")

--------------------
-- Folder Structure
--------------------
local SystemFolder: Folder = ServerScriptService:WaitForChild("System")
local UtilityFolder: Folder = SystemFolder:WaitForChild("Utility")
local AssetsFolder: Folder = ReplicatedStorageService:WaitForChild("Assets")

-------------------
-- Utility Modules
-------------------
local DebugUtility: table = require(UtilityFolder:WaitForChild("DebugUtility"))

--------------------
-- Module Functions
--------------------
function InventoryHandler:Init()
	if self.CreateInventory and self.GenerateSlots and self.IndexNumericToString and self.IndexStringToNumeric and self.ColorStringToInstance and self.GetAvailableSlot and self.CreateInventory and self.UpdateInventory then
		return true
	else
		return false
	end
end

function InventoryHandler:IndexNumericToString(SlotNumber: number): string
	local ConversionTable: table = {
		[1] = "One",
		[2] = "Two",
		[3] = "Three",
		[4] = "Four",
		[5] = "Five",
		[6] = "Six",
		[7] = "Seven",
		[8] = "Eight",
		[9] = "Nine",
		[10] = "Ten",
		[11] = "Eleven",
		[12] = "Twelve",
		[13] = "Thirteen",
		[14] = "Fourteen",
		[15] = "Fifteen",
		[16] = "Sixteen",
	}

	if type(SlotNumber) == "number" then
		return ConversionTable[SlotNumber]
	else
		DebugUtility:Warn("InventoryHandler::ConvertToString", "Invalid parameter type specified - Number expected")
		return nil
	end
end

function InventoryHandler:IndexStringToNumeric(SlotNumber: string): number
	local ConversionTable: table = {
		["One"] = 1,
		["Two"] = 2,
		["Three"] = 3,
		["Four"] = 4,
		["Five"] = 5,
		["Six"] = 6,
		["Seven"] = 7,
		["Eight"] = 8,
		["Nine"] = 9,
		["Ten"] = 10,
		["Eleven"] = 11,
		["Twelve"] = 12,
		["Thirteen"] = 13,
		["Fourteen"] = 14,
		["Fifteen"] = 15,
		["Sixteen"] = 16,
	}

	if type(SlotNumber) == "string" then
		return ConversionTable[SlotNumber]
	else
		DebugUtility:Warn("InventoryHandler::ConvertToString", "Invalid parameter type specified - String expected")
		return nil
	end
end

function InventoryHandler:ColorInstanceToString(ColorInstance: string): string
	local ConversionTable: table = {
		["Bright red"] = "Red",
		["Bright blue"] = "Blue",
		["Bright yellow"] = "Yellow",
		["Dark green"] = "Green"
	}

	if type(ColorInstance) == "string" then
		return ConversionTable[ColorInstance]
	else
		DebugUtility:Warn("InventoryHandler::ColorInstanceToString", "Invalid parameter type specified - String expected")
		return nil
	end
end


function InventoryHandler:ColorStringToInstance(ColorInstance: string): BrickColor
	local ConversionTable: table = {
		["Red"] = BrickColor.new("Bright red"),
		["Blue"] = BrickColor.new("Bright blue"),
		["Yellow"] = BrickColor.new("Bright yellow"),
		["Green"] = BrickColor.new("Dark green")
	}

	if type(ColorInstance) == "string" then
		return ConversionTable[ColorInstance]
	else
		DebugUtility:Warn("InventoryHandler::ColorInstanceToString", "Invalid parameter type specified - String expected")
		return nil
	end
end

function InventoryHandler:GenerateSlots(InventoryFolder: Folder)
	if InventoryFolder.ClassName == "Folder" then
		if InventoryFolder.Name == "Inventory" then
			for InventorySlot = 1, 16, 1 do
				local Slot: StringValue = Instance.new("StringValue", InventoryFolder)
				Slot.Name = "Slot" .. tostring(self:IndexNumericToString(InventorySlot))
				Slot.Value = "N/A"
			end
		else
			DebugUtility:Warn("InventoryHandler::GenerateSlots", "Invalid name specified - Inventory expected")
		end
	else
		DebugUtility:Warn("InventoryHandler::GenerateSlots", "Invalid parameter type specified - Folder expected")
	end
end

function InventoryHandler:GetAvailableSlot(InventoryFolder: Folder): StringValue
	if InventoryFolder.ClassName == "Folder" then
		if InventoryFolder.Name == "Inventory" then
			local TempSlotData: table = {}
			for Index = 1, 16, 1 do
				if InventoryFolder["Slot" .. self:IndexNumericToString(Index)].Value == "N/A" then
					table.insert(TempSlotData, InventoryFolder["Slot" .. self:IndexNumericToString(Index)])
				else
					continue
				end
			end
			return TempSlotData[1]
		else
			DebugUtility:Warn("InventoryHandler::GenerateSlots", "Invalid name specified - Inventory expected")
			return nil
		end
	else
		DebugUtility:Warn("InventoryHandler::GenerateSlots", "Invalid parameter type specified - Folder expected")
		return nil
	end
end

function InventoryHandler:CreateInventory(Player: Player)
	if Player then
		local InventoryFolder: Folder = Instance.new("Folder", Player)
		InventoryFolder.Name = "Inventory"

		self:GenerateSlots(InventoryFolder)

		if #InventoryFolder:GetChildren() < 1 then
			DebugUtility:Warn("InventoryHandler::CreateInventory", "Invalid inventory amount specified")
		end
	else
		DebugUtility:Warn("InventoryHandler::CreateInventory", "Invalid parameter type specified - Player expected")
	end
end

function InventoryHandler:UpdateInventory(Player: Player, ColorData: string, HitInstance: Instance)
	if Player then
		if type(ColorData) == "string" then
			local InventoryFolder: Folder = Player:WaitForChild("Inventory")
			local AvailableSlot: StringValue = self:GetAvailableSlot(InventoryFolder)
			local PlayerInventoryUI: ScreenGui = Player:WaitForChild("PlayerGui"):WaitForChild("InventoryUI")
			local PlayerBackpackFrame: Frame = PlayerInventoryUI:WaitForChild("BackpackFrame")
			local PlayerSlotsFolder: Folder = PlayerBackpackFrame:WaitForChild("Slots")
			local WorldModelClone: WorldModel = AssetsFolder:WaitForChild("WorldModel"):Clone()
			local ViewportCameraClone: Camera = AssetsFolder:WaitForChild("ViewportCamera"):Clone()
			if tostring(AvailableSlot) == "nil" then
				DebugUtility:Warn("InventoryHandler::UpdateInventory", "No available slot found")
			else
				InventoryFolder:WaitForChild(tostring(AvailableSlot)).Value = self:ColorInstanceToString(ColorData)
				WorldModelClone.Parent = PlayerSlotsFolder:WaitForChild(tostring(AvailableSlot))
				ViewportCameraClone.Parent = PlayerSlotsFolder:WaitForChild(tostring(AvailableSlot))
				PlayerSlotsFolder:WaitForChild(tostring(AvailableSlot)).CurrentCamera = ViewportCameraClone
				WorldModelClone:WaitForChild("N/A").BrickColor = self:ColorStringToInstance(self:ColorInstanceToString(ColorData))
				WorldModelClone:WaitForChild("N/A").Name = self:ColorInstanceToString(ColorData)
				HitInstance:Destroy()
			end
		else
			DebugUtility:Warn("InventoryHandler::UpdateInventory", "Invalid parameter type specified - String expected")
		end
	else
		DebugUtility:Warn("InventoryHandler::UpdateInventory", "Invalid parameter type specified - Player expected")
	end
end

return InventoryHandler
