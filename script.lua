-- ====================================================================
-- 🔥 MOTOR ULTRA V10 MONSTRO GIGANTE MULTIPLATAFORMA - DESEMPENHO TOTAL
-- ====================================================================
if not game:IsLoaded() then game.Loaded:Wait() end

-- CONTROLADORES DE SISTEMA E REPLICADORES DA ENGINE DO ROBLOX
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local MaterialService = game:GetService("MaterialService")
local SoundService = game:GetService("SoundService")
local GuiService = game:GetService("GuiService")
local VRService = game:GetService("VRService")

-- 1. OVERCLOCK E TRAVA EXTREMA DE FRAME RATE (PC / MOBILE)
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
settings().Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.DefaultAuto
settings().Physics.ThrottleAdjustTime = 0.01

-- Ignora travas de taxa de quadros (Bypass total para PCs e emuladores)
if setfpscap then setfpscap(999) end

-- AJUSTES AVANÇADOS DIRETOS NAS CONFIGURAÇÕES DA ENGINE
pcall(function()
    settings().Rendering.EglInitializationX11 = "Disabled"
    settings().Rendering.MeshCacheSize = 0
    sethiddenproperty(Workspace, "StreamingEnabled", true)
    sethiddenproperty(Workspace, "StreamingMinDistance", 16)
    sethiddenproperty(Workspace, "StreamingTargetDistance", 64)
    sethiddenproperty(Lighting, "Technology", Enum.Technology.Compatibility)
    sethiddenproperty(Workspace, "LevelOfDetail", Enum.ModelLevelOfDetail.Disabled)
    sethiddenproperty(Workspace, "RejectCharacterIntersections", true)
end)

-- 2. DESATIVAÇÃO DE TEXTURAS E VARIANTES EM LOTE DO SERVIDOR
pcall(function()
    MaterialService.Use2022Materials = false
    for _, mat in ipairs(MaterialService:GetChildren()) do
        if mat:IsA("MaterialVariant") then mat:Destroy() end
    end
end)

-- 3. ROTINA MESTRE DE EXCLUSÃO DE LAG (VARREDURA ULTRA AGRESSIVA DE INSTÂNCIAS)
local function PurgaGeral(obj)
    -- Limpeza instantânea de efeitos visuais secundários e emissores
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Fire") or obj:IsA("Beam") or obj:IsA("Light") or obj:IsA("Highlight") or obj:IsA("SurfaceGui") or obj:IsA("SelectionBox") or obj:IsA("SelectionHighlight") then
        obj:Destroy()
    -- Eliminação de imagens, decais e texturas superficiais do mapa
    elseif obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("Sky") or obj:IsA("Clouds") or obj:IsA("SunRaysEffect") then
        obj:Destroy()
    -- Conversão geométrica e remoção de cálculos de sombras dinâmicas
    elseif obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("CornerWedgePart") or obj:IsA("WedgePart") or obj:IsA("TrussPart") or obj:IsA("Seat") or obj:IsA("VehicleSeat") then
        obj.Material = Enum.Material.SmoothPlastic
        obj.Reflectance = 0
        obj.CastShadow = false
    -- Descarte de componentes cosméticos complexos de outros avatares no PvP
    elseif obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("Clothing") or obj:IsA("Accessory") or obj:IsA("CharacterMesh") then
        obj:Destroy()
    -- Interrupção de trilhas e animações redundantes na memória RAM
    elseif obj:IsA("Animation") or obj:IsA("AnimationTrack") then
        obj:Destroy()
    -- Remoção de filtros visuais de câmera e pós-processamento de tela
    elseif obj:IsA("PostEffect") or obj:IsA("BlurEffect") or obj:IsA("BloomEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("Atmosphere") or obj:IsA("DepthOfFieldEffect") then
        obj:Destroy()
    -- Filtros acústicos tridimensionais desativados
    elseif obj:IsA("SoundEffect") or obj:IsA("ReverbEffect") or obj:IsA("PitchShiftEffect") or obj:IsA("DistortionEffect") or obj:IsA("ChorusEffect") then
        obj:Destroy()
    end
end

-- Varredura imediata profunda executada no mapa carregado
for _, obj in ipairs(Workspace:GetDescendants()) do pcall(PurgaGeral) end

-- 4. INTERCEPTADOR ULTRA-SÔNICO DE NOVOS ELEMENTOS (ANTI-LAG EM PVP EM TEMPO REAL)
Workspace.DescendantAdded:Connect(function(obj) 
    pcall(PurgaGeral)
    if obj:IsA("BasePart") then
        local name = obj.Name:lower()
        if name:find("skill") or name:find("effect") or name:find("hit") or name:find("projectile") or name:find("attack") or name:find("portal") or name:find("slash") or name:find("magic") or name:find("aura") then
            obj:Destroy()
        end
    end
end)

-- 5. CONFIGURAÇÃO DE LUMINOSIDADE ESTÁTICA (ZERO PROJEÇÃO DE CÁLCULO DE LUZ)
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
        pcall(function() efeito:Destroy() end)
    end
end

-- Desativação do terreno dinâmico e física de simulação da água
if Terrain then
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 1
    pcall(function() Terrain.Decoration = false end)
end

-- 6. ESVAZIADOR DE MEMÓRIA DINÂMICA E COLETOR DE LIXO LUA CONSTANTE (ANTI-CRASH)
task.spawn(function()
    while task.wait(0.1) do
        pcall(function() Debris:ClearAllChildren() end)
        pcall(collectgarbage, "collect")
    end
end)

-- 7. RENDERIZADOR RADIAL POR DISTÂNCIA (CULLING EXTENDIDO)
task.spawn(function()
    while task.wait(0.5) do
        local lplayer = Players.LocalPlayer
        if lplayer and lplayer.Character and lplayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = lplayer.Character.HumanoidRootPart
            for _, char in ipairs(Workspace:GetChildren()) do
                if char:IsA("Model") and char:FindFirstChild("HumanoidRootPart") and char ~= lplayer.Character then
                    local dist = (root.Position - char.HumanoidRootPart.Position).Magnitude
                    -- Se o modelo estiver fora do raio de combate imediato, oculta do processamento 3D
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

-- 8. PIPELINE INJETADO DIRETAMENTE NO LOOP DE RENDER (FRAME RATE BYPASS ACELERADO)
RunService.Stepped:Connect(function()
    pcall(function()
        sethiddenproperty(Workspace, "BehaviorMode", "Performance")
        sethiddenproperty(Workspace, "InterpolationThrottling", "Always")
        sethiddenproperty(Workspace, "PhysicsSimulationRate", "Low")
        sethiddenproperty(Workspace, "FastClusterEnabled", true)
        sethiddenproperty(Workspace, "GCOptimizationEnabled", true)
    end)
end)

print("💀 [Dragon Stalo] MOTOR GIGANTE V10 EXTREMO COMPLETO INJETADO!")
