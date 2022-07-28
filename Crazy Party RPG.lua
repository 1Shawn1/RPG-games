--[[
    Author: Shawn#2000
    Game: Crazy Party RPG
    GameId: 9611809130
]]
if getgenv().Ran then return end
getgenv().Ran = true
local LocalPlayer = game.Players.LocalPlayer
local Backpack = LocalPlayer.Backpack
local Mobs = game:GetService("Workspace").Mobs
local DamageRemote = game:GetService("ReplicatedStorage").GameRemotes.DamageEvent

local function GetBestSword()
    local Swords = {}
    local BestDmg = 0
    local BestSword = nil
    if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):FindFirstChild("WeaponConfig") then
        table.insert(Swords, game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"))
    end
    for _, Sword in pairs(Backpack:GetChildren()) do
        if Sword:IsA("Tool") and Sword:FindFirstChild("WeaponConfig") then
            table.insert(Swords, Sword)
        end
    end
    for _,v in pairs(Swords) do
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

local function UnequipTools()
    for _, Tool in pairs(LocalPlayer.Character:GetChildren()) do
        if Tool:IsA("Tool") then
            Tool.Parent = Backpack
        end
    end
end

local function AutoSword()
    while wait(1) do
        if getgenv().AutoEquipSword then
            local BestSword = GetBestSword()
            if not LocalPlayer.Character:FindFirstChild(BestSword) then
                UnequipTools()
                BestSword.Parent = LocalPlayer.Character
            end
        end
    end
end

local function KillEnemys()
    while wait(game:GetService("Stats").PerformanceStats.Ping:GetValue() / 750 * 2)  do
        if getgenv().KillEnemys then
            local MyLevel = LocalPlayer.leaderstats.Level.Value
            for _, Mob in pairs(Mobs:GetChildren()) do
                if Mob:FindFirstChildOfClass("Humanoid") and Mob:FindFirstChildOfClass("Humanoid").Health > 0 and Mob:FindFirstChild("MobConfig") then
                    local MobConfig = require(Mob:FindFirstChild("MobConfig"))
                    if MobConfig.LevelRequiredToKill <= MyLevel then
                        local Part = Mob:FindFirstChildOfClass("Part")
                        local Humanoid = Mob:FindFirstChildOfClass("Humanoid")
                        local Sword = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                        DamageRemote:FireServer(Part, Humanoid, Sword)
                    end
                end
            end
        end
    end
end

spawn(AutoSword)
spawn(KillEnemys)
