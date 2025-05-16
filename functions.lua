local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

local Prefix = getgenv().Data.Prefix
local Master = getgenv().Data.Master

local Bots = getgenv().Data.Bots

local functions = {}

function functions.Chat(Msg)
      if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
  		TextChatService.TextChannels.RBXGeneral:SendAsync(Msg)
  	else
  		ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Msg, "All")
  	end
end
function functions.BotChat(Username, Msg)
      local Index = table.find(Bots, Username) or Username
  
  	for i, v in pairs(Bots) do
  		if Index == i and lp.Name == v then
  			Chat(Msg)
  		end
  	end
end
function functions.ChatAll(Msg)
    for i, v in pairs(Bots) do
  		if lp.Name == v then
  			Chat(Msg)
  
  			break
  		end
  	end
end

return functions
