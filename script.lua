-- OTIMIZADOR DE FPS SUPREMO + GRÁFICOS PARA PVP + REAÇÃO ULTRA RÁPIDA DIRETA
if not game:IsLoaded() then game.Loaded:Wait() end

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")
local Stats = game:GetService("Stats")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- CONFIGURAÇÃO DE VELOCIDADE
local VELOCIDADE_DISCRETA = 20

-- Função ultra leve para manter a velocidade ativada
local function AplicarVelocidade(char)
    if not char then return end
    local humanoid = char:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.WalkSpeed = VELOCIDADE_DISCRETA
    end
end

if LocalPlayer.Character then AplicarVelocidade(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(AplicarVelocidade)

-- Loop leve em segundo plano para garantir que a velocidade não resete
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

-- 1. CONFIGURAÇÕES CRUCIAL DE GRÁFICO (FORÇA O MÍNIMO POSSÍVEL)
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
setfpscap(120)

-- 2. DESTRÓI TEXTURAS E CONVERTE EM PLÁSTICO LISO (MANTÉM JOGADORES VISÍVEIS)
local function OtimizarObjeto(obj)
    if obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("Sky") then
        obj:Destroy()
    elseif obj:IsA("Part") or obj:IsA("MeshPart") or obj:IsA("CornerWedgePart") or obj:IsA("WedgePart") then
        -- Não deleta o jogador, apenas deixa o boneco liso para remover lag
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

-- 3. DESATIVA ILUMINAÇÃO, SOMBRAS E LIMPA BUGS DE TELA A CADA 0.5s
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

-- 4. REAÇÃO DE TOQUE ULTRA RÁPIDA (TELA INTEIRA ATIVA)
local processandoClique = false
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    
    if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) and not processandoClique then
        processandoClique = true
        
        VirtualInputManager:SendMouseButtonEvent(input.Position.X, input.Position.Y, 0, true, game, 0)
        VirtualInputManager:SendMouseButtonEvent(input.Position.X, input.Position.Y, 0, false, game, 0)
        
        task.wait()
        processandoClique = false
    end
end)

-- 5. REMOVE TOTALMENTE OS EFEITOS DA ÁGUA
if Terrain then
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 1
end

-- 6. LIMPEZA DE DETRITOS NO CHÃO
if Workspace:FindFirstChild("Debris") then
    Workspace.Debris:ClearAllChildren()
end

print("[Sucesso] Script Atualizado: Gráficos Otimizados, PVP Visível e Toque Instantâneo!")
