-- Lista de administradores
local Admins = {
    "SeuNomeDeUsuário",  -- Substitua pelo seu nome de jogador
    "OutroNomeDeAdmin"   -- Substitua pelo nome de outro admin
}

-- Lista de jogadores banidos
local BannedPlayers = {}

-- Função para verificar se alguém é admin
local function isAdmin(player)
    for _, adminName in pairs(Admins) do
        if player.Name == adminName then
            return true
        end
    end
    return false
end

-- Função para banir um jogador
local function banPlayer(admin, targetName)
    local targetPlayer = game.Players:FindFirstChild(targetName)
    if targetPlayer then
        table.insert(BannedPlayers, targetName)
        targetPlayer:Kick("Você foi banido por " .. admin.Name)
        print(targetName .. " foi banido por " .. admin.Name)
    else
        admin:Kick("Jogador não encontrado ou já desconectado!")
    end
end

-- Função para desbanir um jogador
local function unbanPlayer(admin, targetName)
    for i, bannedName in pairs(BannedPlayers) do
        if bannedName == targetName then
            table.remove(BannedPlayers, i)
            print(targetName .. " foi desbanido por " .. admin.Name)
            return
        end
    end
    admin:Kick("O jogador " .. targetName .. " não está banido.")
end

-- Função para kickar um jogador
local function kickPlayer(admin, targetName)
    local targetPlayer = game.Players:FindFirstChild(targetName)
    if targetPlayer then
        targetPlayer:Kick("Você foi kickado por " .. admin.Name)
        print(targetName .. " foi kickado por " .. admin.Name)
    else
        admin:Kick("Jogador não encontrado ou já desconectado!")
    end
end

-- Função para enviar mensagens do servidor para o chat
local function sendServerMessage(message)
    local chatEvent = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
    if chatEvent and chatEvent.SayMessageRequest then
        chatEvent.SayMessageRequest:FireServer(message, "All")
    end
end

-- Monitorando jogadores que entram no jogo
game.Players.PlayerAdded:Connect(function(player)
    -- Verifica se o jogador está banido
    for _, bannedName in pairs(BannedPlayers) do
        if player.Name == bannedName then
            player:Kick("Você está banido deste jogo.")
            return
        end
    end

    -- Verifica se o jogador é admin
    if isAdmin(player) then
        sendServerMessage("[server]: Um admin entrou no servidor.")
        print(player.Name .. " é um admin e entrou no jogo.")
    end
end)

-- Evento para detectar comandos no chat
game.Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        if isAdmin(player) then
            local splitMessage = string.split(message, " ")
            local command = splitMessage[1]
            local targetName = splitMessage[2]

            if command == "!ban" and targetName then
                banPlayer(player, targetName)
            elseif command == "!unban" and targetName then
                unbanPlayer(player, targetName)
            elseif command == "!kick" and targetName then
                kickPlayer(player, targetName)
            else
                print("Comando inválido ou incompleto.")
            end
        else
            print(player.Name .. " tentou usar comandos de admin.")
        end
    end)
end)
