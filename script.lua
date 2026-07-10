-- BOOSTER SUPREMO PVP - APENAS FPS SILENCIOSO (DRAGON STALO)
if not game:IsLoaded() then game.Loaded:Wait() end

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")
local Debris = game:GetService("Debris")

-- 1. REDUÇÃO GRÁFICA DIRETA NO MOTOR DO ROBLOX
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
if setfpscap then setfpscap(120) end

-- 2. DESTRUIDOR IMEDIATO DE PARTICULAS E ANIMAÇÕES PESADAS
local function DestruirLag(obj)
    -- Apaga luzes, brilhos, fumaça, fogo, partículas e raios de golpes na hora
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Fire") or obj:IsA("Beam") or obj:IsA("Light") or obj:IsA("Highlight") then
        obj:Destroy()
    -- Tira texturas do chão, paredes e o céu para limpar a RAM
    elseif obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("Sky") then
        obj:Destroy()
    -- Converte o mapa todo em plástico liso sem sombras ou reflexos
    elseif obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("CornerWedgePart") or obj:IsA("WedgePart") then
        obj.Material = Enum.Material.SmoothPlastic
        obj.Reflectance = 0
        obj.CastShadow = false
    -- Remove capas, chapéus, acessórios 3D e roupas dos bonecos no PvP
    elseif obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("Clothing") or obj:IsA("Accessory") then
        obj:Destroy()
    -- Bloqueia a execução de animações de skills pesadas
    elseif obj:IsA("Animation") or obj:IsA("AnimationTrack") then
        obj:Destroy()
    end
end

-- Limpeza inicial profunda de tudo o que já está carregado
for _, obj in ipairs(Workspace:GetDescendants()) do 
    pcall(DestruirLag) 
end

-- 3. MONITORAMENTO PVP EM TEMPO REAL (CORTA O GOLPE DO INIMIGO ANTES DE RENDERIZAR)
Workspace.DescendantAdded:Connect(function(obj) 
    pcall(DestruirLag)
    -- Se a habilidade criar partes físicas ou projéteis no mapa, apaga na hora
    if obj:IsA("BasePart") then
        local name = obj.Name:lower()
        if name:find("skill") or name:find("effect") or name:find("hit") or name:find("projectile") or name:find("attack") or name:find("portal") then
            obj:Destroy()
        end
    end
end)

-- 4. DESATIVAÇÃO DE ILUMINAÇÃO INTERNA DA ATMOSFERA
if Lighting then
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    for _, efeito in ipairs(Lighting:GetChildren()) do
        if efeito:IsA("BlurEffect") or efeito:IsA("SunRaysEffect") or efeito:IsA("BloomEffect") or efeito:IsA("ColorCorrectionEffect") or efeito:IsA("Atmosphere") or efeito:IsA("Clouds") then
            efeito:Destroy()
        end
    end
end

-- 5. REMOVE TOTALMENTE OS GRAFICOS DA ÁGUA
if Terrain then
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 1
end

-- Esvazia a lixeira interna de detritos a cada 0.2 segundos para poupar o gravador
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            Debris:ClearAllChildren()
        end)
    end
end)

print("💀 [Dragon Stalo] MODO FPS ULTRA ATIVADO: Tudo corrigido e revisado!")
