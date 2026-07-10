-- ====================================================================
-- ⚡ MOTOR SUPREMO UNIFICADO V17 - EDICÃO REALME C3 & PC HIGH-SPEED
-- ====================================================================
if not game:IsLoaded() then game.Loaded:Wait() end

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

-- 1. OVERCLOCK GRÁFICO E IGNORADOR DE FPS (PC / MOBILE)
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.DefaultAuto
if setfpscap then setfpscap(999) end

-- 2. INJEÇÃO DE PROPRIEDADES OCULTAS DA ENGINE (REDUZ USO DE CPU)
pcall(function()
    settings().Rendering.MeshCacheSize = 0
    sethiddenproperty(Workspace, "StreamingEnabled", true)
    sethiddenproperty(Workspace, "StreamingMinDistance", 16)
    sethiddenproperty(Workspace, "StreamingTargetDistance", 64)
    sethiddenproperty(Lighting, "Technology", Enum.Technology.Compatibility)
    sethiddenproperty(Workspace, "LevelOfDetail", Enum.ModelLevelOfDetail.Disabled)
    sethiddenproperty(Workspace, "ClientAnimatorThrottling", true)
end)

-- 3. TABELA DE CLASSES A SEREM DESTRUÍDAS (VARREDURA ULTRA RÁPIDA)
local ClassesParaLimpar = {
    "ParticleEmitter", "Trail", "Smoke", "Sparkles", "Fire", "Beam",
    "PointLight", "SpotLight", "SurfaceLight", "Highlight", "SelectionHighlight",
    "SelectionBox", "Texture", "Decal", "Sky", "Clouds", "SunRaysEffect",
    "BlurEffect", "BloomEffect", "ColorCorrectionEffect", "Atmosphere", "DepthOfFieldEffect",
    "Shirt", "Pants", "ShirtGraphic", "Clothing", "Accessory", "CharacterMesh",
    "SoundEffect", "ReverbEffect", "PitchShiftEffect", "DistortionEffect", "ChorusEffect"
}

-- 4. FUNÇÃO MESTRE DE LIMPEZA E OTIMIZAÇÃO GEOMÉTRICA
local function PurgaGeral(obj)
    -- Remove efeitos e texturas pesadas usando a tabela de alta velocidade
    for _, classe in ipairs(ClassesParaLimpar) do
        if obj:IsA(classe) then
            obj:Destroy()
            return
        end
    end
    
    -- Converte blocos 3D para plástico liso e remove sombras (Ganho brutal de FPS)
    if obj:IsA("BasePart") then
        obj.Material = Enum.Material.SmoothPlastic
        obj.Reflectance = 0
        obj.CastShadow = false
    end
end

-- Varredura inicial instantânea no mapa
for _, obj in ipairs(Workspace:GetDescendants()) do pcall(PurgaGeral, obj) end

-- 5. INTERCEPTADOR ANTI-LAG PARA NOVAS SKILLS EM PVP
Workspace.DescendantAdded:Connect(function(obj)
    pcall(PurgaGeral, obj)
    if obj:IsA("BasePart") then
        local name = obj.Name:lower()
        if name:find("skill") or name:find("effect") or name:find("hit") or name:find("projectile") or name:find("attack") or name:find("aura") then
            pcall(function() obj:Destroy() end)
        end
    end
end)

-- 6. CONFIGURAÇÃO DE LUZ ESTÁTICA E LIMPEZA DA ATMOSFERA
if Lighting then
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 1
    for _, efeito in ipairs(Lighting:GetChildren()) do pcall(function() efeito:Destroy() end) end
end

local Terrain = Workspace:FindFirstChildOfClass("Terrain")
if Terrain then
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterTransparency = 1
    pcall(function() Terrain.Decoration = false end)
end

-- 7. COLETOR DE LIXO DA MEMÓRIA RAM (EVITA CRASH NO MOBILE)
task.spawn(function()
    while task.wait(0.5) do
        pcall(function() Debris:ClearAllChildren() end)
        pcall(collectgarbage, "collect")
    end
end)

-- 8. SISTEMA DE CULLING RADIAL (REDUZ RENDER DE JOGADORES DISTANTES)
task.spawn(function()
    while task.wait(0.5) do
        local lplayer = Players.LocalPlayer
        if lplayer and lplayer.Character and lplayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = lplayer.Character.HumanoidRootPart
            for _, char in ipairs(Workspace:GetChildren()) do
                if char:IsA("Model") and char:FindFirstChild("HumanoidRootPart") and char ~= lplayer.Character then
                    local dist = (root.Position - char.HumanoidRootPart.Position).Magnitude
                    -- Oculta avatares fora do raio de combate para poupar a GPU do Helio G70
                    local mod = dist > 150 and 1 or 0
                    for _, p in ipairs(char:GetDescendants()) do
                        if p:IsA("BasePart") then p.LocalTransparencyModifier = mod end
                    end
                end
            end
        end
    end
end)

-- 9. RE-INJEÇÃO DE PERFORMANCE A CADA FRAME (ESTABILIDADE TOTAL)
RunService.Stepped:Connect(function()
    pcall(function()
        sethiddenproperty(Workspace, "BehaviorMode", "Performance")
        sethiddenproperty(Workspace, "InterpolationThrottling", "Always")
        sethiddenproperty(Workspace, "PhysicsSimulationRate", "Low")
        sethiddenproperty(Workspace, "FastClusterEnabled", true)
    end)
end)

print("💀 [Dragon Stalo] O MELHOR MOTOR FOI INJETADO! FOCO EM FLUIDEZ REAL.")
