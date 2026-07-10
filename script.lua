-- BOOSTER SUPREMO + ANTI-CRASH MOBILE (DRAGON STALO)
if not game:IsLoaded() then game.Loaded:Wait() end

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")
local Debris = game:GetService("Debris")

-- 1. OTIMIZAÇÃO DE MOTOR GRÁFICO (NÍVEL HARDWARE)
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
if setfpscap then setfpscap(120) end
if sethiddenproperty then
    sethiddenproperty(Lighting, "Technology", Enum.Technology.Compatibility)
end

-- 2. LIMPEZA TOTAL DE OBJETOS E TEXTURAS
local function DestruirLag(obj)
    -- Remove na hora efeitos de luz, brilho, fumaça, fogo e partículas
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Fire") or obj:IsA("Beam") or obj:IsA("Light") or obj:IsA("Highlight") then
        obj:Destroy()
    -- Tira o céu, fotos das paredes e chão
    elseif obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("Sky") then
        obj:Destroy()
    -- Gráfico de Plástico Absoluto (Sem sombras e sem reflexos)
    elseif obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("CornerWedgePart") or obj:IsA("WedgePart") then
        obj.Material = Enum.Material.SmoothPlastic
        obj.Reflectance = 0
        obj.CastShadow = false
    -- Remove roupas 2D/3D dos personagens (Economiza muita RAM no PvP)
    elseif obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("Clothing") or obj:IsA("Accessory") then
        obj:Destroy()
    -- Corta animações pesadas
    elseif obj:IsA("Animation") or obj:IsA("AnimationTrack") then
        obj:Destroy()
    end
end

-- Varredura Inicial no Mapa
for _, obj in ipairs(Workspace:GetDescendants()) do 
    pcall(DestruirLag) 
end

-- 3. MONITORAMENTO AGRESSIVO EM TEMPO REAL (PVP IMEDIATO)
Workspace.DescendantAdded:Connect(function(obj) 
    pcall(DestruirLag)
    -- Se o golpe criar partes físicas no mapa (bolas de poder, paredes, etc), deleta na hora
    if obj:IsA("BasePart") then
        local name = obj.Name:lower()
        if name:find("skill") or name:find("effect") or name:find("hit") or name:find("projectile") or name:find("attack") then
            obj:Destroy()
        end
    end
end)

-- 4. LIMPEZA DE ATMOSFERA E EFEITOS DE TELA
local function LimparFiltros()
    if Lighting then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        for _, efeito in ipairs(Lighting:GetChildren()) do
            if efeito:IsA("BlurEffect") or efeito:IsA("SunRaysEffect") or efeito:IsA("BloomEffect") or efeito:IsA("ColorCorrectionEffect") or efeito:IsA("Atmosphere") or efeito:IsA("Clouds") then
                efeito:Destroy()
            end
        end
    end
end
LimparFiltros()

-- 5. DESTRUIÇÃO DE RECURSOS INÚTEIS (ÁGUA E DEBRIS)
if Terrain then
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 1
end

-- Limpa a pasta de detritos do jogo repetidamente para não acumular lixo na RAM
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            Debris:ClearAllChildren()
        end)
    end
end)

print("🚀 SCRIPT REFORMULADO: Otimização máxima aplicada com sucesso!")
