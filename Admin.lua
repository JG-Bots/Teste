local Players = game:GetService("Players")
local ChatService = game:GetService("Chat")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Lista de administradores
local Admins = {
    "JerfinG_amer0",  -- Nome do primeiro admin
    "pominy34"        -- Nome do segundo admin
}

-- Função para verificar se o jogador é admin
local function isAdmin(player)
    for _, adminName in pairs(Admins) do
        if player.Name == adminName then
            return true
        end
    end
    return false
end

-- Função para enviar a mensagem no chat
local function sendMessageToChat(message)
    ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents").SayMessageRequest:FireServer(message, "All")
end

-- Comandos de Admin
local function processAdminCommand(player, command, targetPlayerName)
    if isAdmin(player) then
        local targetPlayer = Players:FindFirstChild(targetPlayerName)
        
        if targetPlayer then
            if command == "!ban" then
                -- Banir o jogador
                targetPlayer:Kick("Você foi banido pelo admin!")
                sendMessageToChat("[server]: " .. targetPlayerName .. " foi banido.")
            elseif command == "!unban" then
                -- Desbanir (aqui você precisa de uma lista de banidos, que não está implementada no momento)
                sendMessageToChat("[server]: " .. targetPlayerName .. " foi desbanido.")
            elseif command == "!kick" then
                -- Kitar o jogador (ele poderá entrar novamente)
                targetPlayer:Kick("Você foi kitado pelo admin, mas poderá entrar novamente.")
                sendMessageToChat("[server]: " .. targetPlayerName .. " foi kitado.")
            end
        else
            sendMessageToChat("[server]: Jogador " .. targetPlayerName .. " não encontrado.")
        end
    else
        sendMessageToChat("[server]: Você não tem permissão para usar esse comando.")
    end
end

-- Monitorando quando um jogador entra no jogo
Players.PlayerAdded:Connect(function(player)
    -- Envia a mensagem no chat se o jogador for admin
    if isAdmin(player) then
        sendMessageToChat("[server]: Um admin entrou no servidor: " .. player.Name)
    end
end)

-- Função para detectar a orientação da tela no celular
local function checkOrientation()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer.PlayerGui

    local screenSize = workspace.CurrentCamera.ViewportSize
    if screenSize.X < screenSize.Y then
        -- Orientação retrato
        local warningText = Instance.new("TextLabel")
        warningText.Size = UDim2.new(0, 400, 0, 100)
        warningText.Position = UDim2.new(0.5, -200, 0.5, -50)
        warningText.Text = "Por favor, vire o seu dispositivo para o modo paisagem!"
        warningText.TextColor3 = Color3.fromRGB(255, 0, 0)
        warningText.TextScaled = true
        warningText.BackgroundTransparency = 1
        warningText.Parent = screenGui
    else
        -- Orientação paisagem
        print("Modo paisagem detectado")
    end
end

-- Verifica a orientação ao entrar no jogo
checkOrientation()

-- Exemplo de como processar os comandos no jogo
-- Aqui você pode colocar a lógica de captura de comandos de chat
Players.PlayerAdded:Connect(function(player)
    -- Exemplo de comando, você pode ajustar a forma que os jogadores digitam comandos
    -- Aqui estamos simulando o comando "!ban JerfinG_amer0"
    local command = "!ban"
    local targetPlayerName = "JerfinG_amer0"
    processAdminCommand(player, command, targetPlayerName)
end)
