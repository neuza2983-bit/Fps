-- OTIMIZADOR SUPREMO PVP (ANTI-LAG TOTAL)
if not game:IsLoaded() then game.Loaded:Wait() end

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")

-- 1. CONFIGURAÇÃO DE RENDERIZAÇÃO NO MÍNIMO
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
if setfpscap then setfpscap(120) end

-- 2. FUNÇÃO DESTRUIDORA DE LAG (DELETA NA HORA)
local function OtimizarObjeto(obj)
    -- Remove partículas, fumaça, raios e efeitos de skills/armas
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Fire") or obj:IsA("Beam") or obj:IsA("Light") then
        obj:Destroy()
    -- Remove texturas do mapa e o céu pesados
    elseif obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("Sky") then
        obj:Destroy()
    -- Transforma o mapa em plástico liso e tira sombras
    elseif obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("CornerWedgePart") or obj:IsA("WedgePart") then
        obj.Material = Enum.Material.SmoothPlastic
        obj.Reflectance = 0
        obj.CastShadow = false
    -- Remove roupas pesadas que sobrecarregam a RAM
    elseif obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") then
        obj:Destroy()
    -- Desativa animações pesadas no meio do PvP
    elseif obj:IsA("Animation") then
        obj:Destroy()
    end
end

-- Limpeza inicial profunda
for _, obj in ipairs(Workspace:GetDescendants()) do 
    pcall(OtimizarObjeto) 
end

-- Monitoramento em tempo real (Sumiu com o golpe assim que usarem)
Workspace.DescendantAdded:Connect(function(obj) 
    pcall(OtimizarObjeto)
    if obj:IsA("BasePart") and (obj.Name:lower():find("skill") or obj.Name:lower():find("effect") or obj.Name:lower():find("hit")) then
        task.wait()
        obj:Destroy()
    end
end)

-- 3. LIMPEZA DE FILTROS E BUGS DA TELA
local function LimparFiltros()
    if Lighting then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        for _, efeito in ipairs(Lighting:GetChildren()) do
            if efeito:IsA("BlurEffect") or efeito:IsA("SunRaysEffect") or efeito:IsA("BloomEffect") or efeito:IsA("ColorCorrectionEffect") then
                efeito:Destroy()
            end
        end
    end
end
LimparFiltros()

-- 4. REMOVE EFEITOS DA ÁGUA
if Terrain then
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 1
end

print("⚡ [Dragon Stalo] Modo Ultra FPS Ativado! Tudo limpo.")
