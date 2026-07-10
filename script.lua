-- ====================================================================
-- 🔥 MOTOR UNIFICADO MULTIPLATAFORMA V8 MASTER - DESEMPENHO ABSOLUTO
-- ====================================================================
if not game:IsLoaded() then game.Loaded:Wait() end

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local MaterialService = game:GetService("MaterialService")

-- 1. OVERCLOCK GRÁFICO SELETIVO (PC / MOBILE DETECTION & TUNING)
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.DefaultAuto
settings().Physics.ThrottleAdjustTime = 0.01

-- Ignora travas de taxa de quadros nativas (Bypass total para PCs e emuladores)
if setfpscap then setfpscap(999) end

pcall(function()
    settings().Rendering.EglInitializationX11 = "Disabled"
    sethiddenproperty(Workspace, "StreamingEnabled", true)
    sethiddenproperty(Workspace, "StreamingMinDistance", 16)
    sethiddenproperty(Workspace, "StreamingTargetDistance", 64)
    sethiddenproperty(Lighting, "Technology", Enum.Technology.Compatibility)
end)

-- 2. LIMPEZA TOTAL DE EFEITOS E OBJETOS TRIDIMENSIONAIS
local function PurgaGeral(obj)
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Fire") or obj:IsA("Beam") or obj:IsA("Light") or obj:IsA("Highlight") or obj:IsA("SurfaceGui") then
        obj:Destroy()
    elseif obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("Sky") or obj:IsA("Clouds") then
        obj:Destroy()
    elseif obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("CornerWedgePart") or obj:IsA("WedgePart") or obj:IsA("TrussPart") or obj:IsA("Seat") then
        obj.Material = Enum.Material.SmoothPlastic
        obj.Reflectance = 0
        obj.CastShadow = false
    elseif obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("Clothing") or obj:IsA("Accessory") then
        obj:Destroy()
    elseif obj:IsA("Animation") or obj:IsA("AnimationTrack") then
        obj:Destroy()
    elseif obj:IsA("PostEffect") or obj:IsA("BlurEffect") or obj:IsA("SunRaysEffect") then
        obj:Destroy()
    elseif obj:IsA("SoundEffect") or obj:IsA("ReverbEffect") or obj:IsA("PitchShiftEffect") then
        obj:Destroy()
    end
end

-- Varredura pesada imediata ao carregar
for _, obj in ipairs(Workspace:GetDescendants()) do pcall(PurgaGeral) end

-- 3. CONSTANTE DE INTERCEPTAÇÃO DE SKILLS EM TEMPO REAL
Workspace.DescendantAdded:Connect(function(obj) 
    pcall(PurgaGeral)
    if obj:IsA("BasePart") then
        local name = obj.Name:lower()
        if name:find("skill") or name:find("effect") or name:find("hit") or name:find("projectile") or name:find("attack") or name:find("portal") or name:find("slash") or name:find("magic") then
            obj:Destroy()
        end
    end
end)

-- 4. AMBIENTE ESTÁTICO SEM CÁLCULOS DE LUZ OU SOMBRA
if Lighting then
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.FogStart = 9e9
    Lighting.Brightness = 1
    Lighting.ShadowSoftness = 0
    Lighting.EnvironmentLightingScale = 0
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    for _, efeito in ipairs(Lighting:GetChildren()) do
        if efeito:IsA("BlurEffect") or efeito:IsA("SunRaysEffect") or efeito:IsA("BloomEffect") or efeito:IsA("ColorCorrectionEffect") or efeito:IsA("Atmosphere") then
            efeito:Destroy()
        end
    end
end

-- Tira decorações de grama e água realista
if Terrain then
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 1
    pcall(function() Terrain.Decoration = false end)
end

-- 5. LIMPADOR DE RAM AGRESSIVO E COLETA DE LIXO LUA
task.spawn(function()
    while task.wait(0.1) do
        pcall(function() Debris:ClearAllChildren() end)
        pcall(collectgarbage, "collect")
    end
end)

-- 6. CULLING POR DISTÂNCIA PARA MODELOS IRRELEVANTES
task.spawn(function()
    while task.wait(0.5) do
        local lplayer = Players.LocalPlayer
        if lplayer and lplayer.Character and lplayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = lplayer.Character.HumanoidRootPart
            for _, char in ipairs(Workspace:GetChildren()) do
                if char:IsA("Model") and char:FindFirstChild("HumanoidRootPart") and char ~= lplayer.Character then
                    local dist = (root.Position - char.HumanoidRootPart.Position).Magnitude
                    if dist > 150 then
                        for _, p in ipairs(char:GetDescendants()) do
                            if p:IsA("BasePart") then p.LocalTransparencyModifier = 1 end
                        end
                    else
                        for _, p in ipairs(char:GetDescendants()) do
                            if p:IsA("BasePart") then p.LocalTransparencyModifier = 0 end
                        end
                    end
                end
            end
        end
    end
end)

-- 7. PIPELINE ACELERADO PARA ATUALIZAÇÃO FÍSICA CONSTANTE
RunService.Stepped:Connect(function()
    pcall(function()
        sethiddenproperty(Workspace, "BehaviorMode", "Performance")
        sethiddenproperty(Workspace, "InterpolationThrottling", "Always")
        sethiddenproperty(Workspace, "PhysicsSimulationRate", "Low")
    end)
end)

print("💥 [Dragon Stalo] COMBO PC/MOBILE HIBRID V8 INJETADO COM SUCESSO!")
