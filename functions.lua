local load_start = tick()

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

local SendCommand = loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzmrchicken/DefigureBotCTRL/refs/heads/main/commands.lua"))()
print(string.format("[%.2f] commands.lua", (tick()-load_start)*1000))

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
  			functions.Chat(Msg)
  		end
  	end
end
function functions.ChatAll(Msg)
    for i, v in pairs(Bots) do
  		if lp.Name == v then
  			functions.Chat(Msg)
  
  			break
  		end
  	end
end

function functions.load()
      print("###########################")
      print("###########################")
      print("🔁Loading DefigureBotCTRL...🔁")
      
      task.wait(1)
      
      for _, player in pairs(Players:GetPlayers()) do
      	player.Chatted:Connect(function(Message)
      		-- if player.Name ~= Master then return end
      		if player.Name ~= Master and not table.find(Bots, player.Name) then return end
      
      		SendCommand(Message, functions)
      	end)
      end
      for i, v in pairs(Bots) do
      	if lp.Name == v then
                  if getgenv().Data.ExecuteAnnounce then
                        functions.Chat("DefigureBotCTRL has loaded "..v..". Use "..Prefix.."cmds to view commands")
                  end
      
      		break
      	end
      
      	task.wait()
      end
      
      print("✅Bots Loaded✅")
      print("###########################")
      print("###########################")
end

print(string.format("[%.2f] functions.lua", (tick()-load_start)*1000))

return functions
