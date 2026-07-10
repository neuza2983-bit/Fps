-- OTIMIZADOR ABSOLUTO + ZERO LAG PVP (DRAGON STALO)
if not game:IsLoaded() then game.Loaded:Wait() end

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")
local Debris = game:GetService("Debris")

-- 1. REDUÇÃO GRÁFICA NO LIMITE DO MOTOR
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
if setfpscap then setfpscap(120) end

-- 2. DESTRUIDOR DE INSTÂNCIAS (LIMPEZA TOTAL)
local function LimpezaGeral(obj)
    -- Deleta na hora: Partículas, Raios, Luzes, Fumaça, Fogo e Efeitos Visuais (De todas as frutas/armas)
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Fire") or obj:IsA("Beam") or obj:IsA("Light") or obj:IsA("Highlight") then
        obj:Destroy()
    -- Deleta texturas de blocos, imagens de paredes e o céu do jogo
    elseif obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("Sky") then
        obj:Destroy()
    -- Modo Plástico Total: Tira reflexo, sombras e muda o material de todo o mapa
    elseif obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("CornerWedgePart") or obj:IsA("WedgePart") then
        obj.Material = Enum.Material.SmoothPlastic
        obj.Reflectance = 0
        obj.CastShadow = false
    -- Remove capas, chapéus, espadas nas costas e roupas dos bonecos (Alivia muita RAM)
    elseif obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("Clothing") or obj:IsA("Accessory") then
        obj:Destroy()
    -- Bloqueia e desativa animações pesadas de golpes
    elseif obj:IsA("Animation") or obj:IsA("AnimationTrack") then
        obj:Destroy()
    end
end

-- Limpa tudo o que já está carregado no servidor
for _, obj in ipairs(Workspace:GetDescendants()) do 
    pcall(LimpezaGeral) 
end

-- 3. MONITORAMENTO AGRESSIVO (NADA RECENTE SOBREVIVE)
Workspace.DescendantAdded:Connect(function(obj) 
    pcall(LimpezaGeral)
    -- Se qualquer poder criar uma parte física no mapa (bolas de energia, paredes, portais), apaga na hora
    if obj:IsA("BasePart") then
        local name = obj.Name:lower()
        if name:find("skill") or name:find("effect") or name:find("hit") or name:find("projectile") or name:find("attack") or name:find("portal") then
            obj:Destroy()
        end
    end
end)

-- 4. DESATIVAÇÃO DE ILUMINAÇÃO INTERNA
if Lighting then
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    for _, efeito in ipairs(Lighting:GetChildren()) do
        if efeito:IsA("BlurEffect") or efeito:IsA("SunRaysEffect") or efeito:IsA("BloomEffect") or efeito:IsA("ColorCorrectionEffect") or efeito:IsA("Atmosphere") or efeito:IsA("Clouds") then
            efeito:Destroy()
        end
    end
end

-- 5. REMOVE TOTALMENTE A FÍSICA DA ÁGUA
if Terrain then
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 1
end

-- Esvazia a lixeira de detritos do Roblox sem parar
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            Debris:ClearAllChildren()
        end)
    end
end)

print("💀 [Dragon Stalo] APOCALYPSE FPS: Absolutamente tudo o que causava lag foi deletado!")
