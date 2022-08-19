--[[
    Author: Shawn#2000
    Game: Crazy Party RPG
    GameId: 9611809130
]]
getgenv().Settings = {
	On = false,
	Range = 10,
	Larry = false,
	AutoEquip = false
}

local library = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ShaddowScripts/Main/main/Library2"))()
local LocalPlayer = game.Players.LocalPlayer
local Backpack = LocalPlayer.Backpack
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Mobs = game:GetService("Workspace").Mobs
local DamageRemote = game:GetService("ReplicatedStorage").GameRemotes.DamageEvent
local CrazyRPG = library:CreateWindow("Crazy RPG")

local function GetBestSword()
	local Swords = {}
	local BestDmg = 0
	local BestSword = nil
	if Character:FindFirstChildOfClass("Tool") and Character:FindFirstChildOfClass("Tool"):FindFirstChild("WeaponConfig") then
		table.insert(Swords,Character:FindFirstChildOfClass("Tool"))
	end
	for _, Sword in pairs(Backpack:GetChildren()) do
		if Sword:IsA("Tool") and Sword:FindFirstChild("WeaponConfig") then
			table.insert(Swords, Sword)
		end
	end
	for _, v in pairs(Swords) do
		if v:FindFirstChild("WeaponConfig") then
			local Damage = require(v:FindFirstChild("WeaponConfig")).MaxDamage
			if typeof(Damage) == "number" and Damage > BestDmg then
				BestDmg = Damage
				BestSword = v
			end
		end
	end
	return BestSword
end


CrazyRPG:CreateCheckbox("Kill Aura", function(bool)
	getgenv().Settings.On = bool
end)

CrazyRPG:CreateSlider("Kill Aura Range", 1, 20, function(num)
	getgenv().Settings.Range = num
end)

CrazyRPG:CreateCheckbox("Auto equip best sword", function(bool)
	getgenv().Settings.AutoEquip = bool
end)


if game.PlaceId == 9611809130 then
	CrazyRPG:CreateCheckbox("Loop tp to golden larry", function(bool)
		getgenv().Settings.Larry = bool
	end)
end

local function UnequipTools()
	for _, Tool in pairs(Character:GetChildren()) do
		if Tool:IsA("Tool") then
			Tool.Parent = Backpack
		end
	end
end

local function KillAura()
	while wait() do
		if getgenv().Settings.On then
			for _, Mob in pairs(Mobs:GetChildren()) do
				if Mob:FindFirstChildOfClass("Humanoid") and Mob:FindFirstChildOfClass("Humanoid").Health > 0 then
					local HRP = Character:WaitForChild("HumanoidRootPart", 1) or nil
					local Part = Mob:FindFirstChildOfClass("Part")
					local Humanoid = Mob:FindFirstChildOfClass("Humanoid")
					local Sword = Character:FindFirstChildOfClass("Tool") or nil
					if Sword and Part and HRP and (Part.Position - HRP.Position).Magnitude <= getgenv().Settings.Range then
						DamageRemote:FireServer(Part, Humanoid, Sword)
					end
				end
			end
		end
	end
end

local function AutoSword()
	while wait(1) do
		if getgenv().Settings.AutoEquip then
			local BestSword = GetBestSword()
			if Character and not Character:FindFirstChild(BestSword) then
				UnequipTools()
				BestSword.Parent = Character
			end
		end
	end
end

local function Larry()
	local Part = Instance.new("Part", game.Workspace)
	Part.Size = Vector3.new(2, 0.2, 2)
	Part.CanCollide = true
	Part.Anchored = true
	Part.Transparensy = 1

	while task.wait() do
		if getgenv().Settings.Larry then
			local HRP = Character:WaitForChild("HumanoidRootPart", 1) or nil
			local Mob = game:GetService("Workspace").Mobs:FindFirstChild("elden lober") and game:GetService("Workspace").Mobs:FindFirstChild("elden lober"):FindFirstChild("Torso") or nil
			if Character and HRP and Mob then
				HRP.CFrame = Mob.CFrame * CFrame.new(0, getgenv().Settings.Range - 1, 0)
				Part.CFrame = HRP.CFrame * CFrame.new(0, -3.1, 0)
			end
		end
	end
end

spawn(AutoSword)
spawn(KillAura)
spawn(Larry)
