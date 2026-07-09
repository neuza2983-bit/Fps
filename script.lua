-- OTIMIZADOR SUPREMO + CLIQUE SEGURO (SEM TRAVAR O ANALÓGICO / BLOX FRUITS)
if not game:IsLoaded() then game.Loaded:Wait() end

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- CONFIGURAÇÃO DE VELOCIDADE
local VELOCIDADE_DISCRETA = 20

local function AplicarVelocidade(char)
    if not char then return end
    local humanoid = char:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.WalkSpeed = VELOCIDADE_DISCRETA
    end
end

if LocalPlayer.Character then AplicarVelocidade(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(AplicarVelocidade)

task.spawn(function()
    while task.wait(1.5) do
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.WalkSpeed ~= VELOCIDADE_DISCRETA then
                humanoid.WalkSpeed = VELOCIDADE_DISCRETA
            end
        end
    end
end)

-- 1. CONFIGURAÇÕES INTERNAS DE RENDERIZAÇÃO
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
setfpscap(120)

-- 2. DESTRÓI TEXTURAS E CONVERTE EM PLÁSTICO LISO (MANTÉM JOGADORES VISÍVEIS)
local function OtimizarObjeto(obj)
    if obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("Sky") then
        obj:Destroy()
    elseif obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("CornerWedgePart") or obj:IsA("WedgePart") then
        obj.Material = Enum.Material.SmoothPlastic
        obj.Reflectance = 0
        obj.CastShadow = false
    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Fire") then
        obj.Enabled = false
    elseif obj:IsA("Explosion") then
        obj.Visible = false
    elseif obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") then
        obj:Destroy()
    end
end

for _, obj in ipairs(Workspace:GetDescendants()) do pcall(OtimizarObjeto) end
Workspace.DescendantAdded:Connect(function(obj) pcall(OtimizarObjeto) end)

-- 3. DESATIVA ILUMINAÇÃO, SOMBRAS E LIMPA BUGS DE TELA (ANTI-PORTAL)
local function LimparFiltrosEBugs()
    if Lighting then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 1
        
        for _, efeito in ipairs(Lighting:GetChildren()) do
            if efeito:IsA("BlurEffect") or efeito:IsA("SunRaysEffect") or efeito:IsA("BloomEffect") or efeito:IsA("DepthOfFieldEffect") or efeito:IsA("ColorCorrectionEffect") then
                efeito:Destroy()
            end
        end
    end

    if Workspace.CurrentCamera then
        for _, v in ipairs(Workspace.CurrentCamera:GetChildren()) do
            v:Destroy()
        end
    end
end

LimparFiltrosEBugs()
task.spawn(function()
    while task.wait(0.5) do
        LimparFiltrosEBugs()
    end
end)

-- 4. CLIQUE AUTOMÁTICO SEGURO EM SEGUNDO PLANO (NÃO TRAVA O ANALÓGICO)
task.spawn(function()
    while task.wait(0.1) do
        -- Simula o clique apenas se você estiver segurando uma ferramenta/arma na mão
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool") then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
    end
end)

-- 5. REMOVE TOTALMENTE OS EFEITOS DA ÁGUA E LIMPA CHÃO
if Terrain then
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 1
end

if Workspace:FindFirstChild("Debris") then
    Workspace.Debris:ClearAllChildren()
end

print("[Sucesso] Script de Blox Fruits com Clique Seguro e Sem Lag Ativado!")
