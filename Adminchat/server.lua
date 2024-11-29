local adminChatEnabled = {}

-- Ellenőrzi, hogy a játékos admin-e
local function isAdmin(source)
    return true
end

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local src = source
    if isAdmin(src) then
        adminChatEnabled[src] = true
    end
end)

-- /adminchat parancs adminoknak, hogy ki/be kapcsolják az adminchatet
RegisterCommand('adminchat', function(source, args, rawCommand)
    if not isAdmin(source) then
        TriggerClientEvent('chat:addMessage', source, {
            args = {"^1Nincs jogod ehhez a parancshoz!"},
            color = {255, 0, 0}
        })
        return
    end

    -- Admin chat állapotának kapcsolása
    if adminChatEnabled[source] then
        adminChatEnabled[source] = nil
        TriggerClientEvent('chat:addMessage', source, {
            args = {
                "^1AdminChat Kikapcsolva"
            },
            color = {255, 165, 0}, -- Kiemelt narancssárga színnel
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255,44,44, 0.6); border-radius: 3px;"><i class="fas fa-exclamation-triangle"></i> {0}</div>'
        })
    else
        adminChatEnabled[source] = true
        TriggerClientEvent('chat:addMessage', source, {
            args = {
                "^1AdminChat Bekapcsolva"
            },
            color = {255, 165, 0}, -- Kiemelt narancssárga színnel
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(255,44,44, 0.6); border-radius: 3px;"><i class="fas fa-exclamation-triangle"></i> {0}</div>'
        })
    end
end, false)

-- Üzenetek figyelése (ha nincs perjel, akkor adminchat)
AddEventHandler('chatMessage', function(source, name, message)
    if adminChatEnabled[source] then
        CancelEvent() -- Megakadályozzuk, hogy a nyilvános chatbe menjen az üzenet

        -- Üzenet küldése adminoknak
        for _, playerId in ipairs(GetPlayers()) do
            if isAdmin(playerId) then
                TriggerClientEvent('chat:addMessage', playerId, {
                    args = {
                        "^5[Admin Chat] ^7| ^3[" .. source .. "] " .. GetPlayerName(source) .. "^7: " .. message
                    },
                    color = {255, 165, 0}, -- Admin chat üzenet szín
                    template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 0, 0, 0.6); border-radius: 3px;"><i class="fas fa-shield-alt"></i> {0}</div>'
                })
            end
        end
    end
end)

-- Amikor egy admin kilép, töröljük a beállításait
AddEventHandler('playerDropped', function(reason)
    local src = source
    if adminChatEnabled[src] then
        adminChatEnabled[src] = nil
    end
end)
