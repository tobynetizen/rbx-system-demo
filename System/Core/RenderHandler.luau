--  ____                _
-- |  _ \ ___ _ __   __| | ___ _ __
-- | |_) / _ \ '_ \ / _` |/ _ \ '__|
-- |  _ <  __/ | | | (_| |  __/ |
-- |_| \_\___|_| |_|\__,_|\___|_|
--
--  +------------------------------+
--  | AUTHOR  | TwilightAnxiety    |
--  | ---------------------------- |
--  | FILE    | RenderHandler.luau |
--  +------------------------------+

local RenderHandler: table = {}

---------------
-- Module Data
---------------
local PartColors: table = {
	[1] = BrickColor.Red(),
	[2] = BrickColor.Blue(),
	[3] = BrickColor.Green(),
	[4] = BrickColor.Yellow()
}

------------------
-- Module Methods
------------------
function RenderHandler:Init()
	if self.Start and self.GeneratePart then
		return true
	else
		return false
	end
end

function RenderHandler:GeneratePart()
	local Part: Part = Instance.new("Part", workspace:WaitForChild("Map"))
	Part.Anchored = true
	Part.CanCollide = true
	Part.CanQuery = true
	Part.CanTouch = true
	Part.Archivable = true
	Part.Name = "N/A"
	Part.BrickColor = PartColors[math.random(1, #PartColors)]
	Part.Material = Enum.Material.SmoothPlastic
	Part.Size = Vector3.new(2, 2, 2)
	Part.Position = Vector3.new(
		math.random(-(workspace.Baseplate.Size.X - 5) / 2, (workspace.Baseplate.Size.X - 5) / 2),
		((workspace.Baseplate.Position.Y + workspace.Baseplate.Size.Y) / 2) + Part.Size.Y / 2,
		math.random(-(workspace.Baseplate.Size.Z - 5) / 2, (workspace.Baseplate.Size.Z - 5) / 2)
	)
end

function RenderHandler:Start(Amount: number)
	for PartIndex = 1, Amount, 1 do
		self:GeneratePart()
	end
end

return RenderHandler
