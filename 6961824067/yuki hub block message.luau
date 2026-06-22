-- ===== ANTI REKLAM (всё скрыть) =====

-- Новый чат (TextChatService)
local TextChatService = game:FindService("TextChatService")
if TextChatService then
    TextChatService.OnIncomingMessage = function(message)
        -- скрываем любые сообщения от хабов/рекламы
        if message.Text then
            local t = message.Text:lower()
            if t:find("hub") or t:find("discord") or t:find("http")
                or t:find("gg/") or t:find("script")
                or t:find("yuki") or t:find("❤") then
                return nil
            end
        end
        return message
    end
end

-- Старый чат
local Chat = game:GetService("Chat")
local old = Chat.OnMessageDoneFiltering
Chat.OnMessageDoneFiltering = function(self, msg)
    if msg and msg.Message then
        local t = msg.Message:lower()
        if t:find("hub") or t:find("discord") or t:find("http")
            or t:find("gg/") or t:find("script")
            or t:find("yuki") or t:find("❤") then
            msg.Message = "" -- полностью скрыть
        end
    end
    return old(self, msg)
end
