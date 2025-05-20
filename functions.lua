local load_start = tick()

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

local SendCommand = loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzmrchicken/DefigureBotCTRL/refs/heads/main/commands.lua"))()
print(string.format("[%.2f] commands.lua", (tick()-load_start)*1000))
local version = loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzmrchicken/DefigureBotCTRL/refs/heads/main/version.lua"))()
print(string.format("[%.2f] version.lua", (tick()-load_start)*1000))

local Prefix = getgenv().Data.Prefix
local Master = getgenv().Data.Master

local Whitelist = getgenv().Data.WhitelistControl

local Bots = getgenv().Data.Bots

local functions = {}

function functions.Chat(Msg)
      if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
  		TextChatService.TextChannels.RBXGeneral:SendAsync(Msg)
  	else
  		ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Msg, "All")
  	end
end
function functions.IsModernChat()
      if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
  		return false
  	else
  		return true
      end  
end
function functions.BotChat(Username, Msg)
      local Index = table.find(Bots, Username) or Username
  
  	for i, v in pairs(Bots) do
  		if Index == i and lp.Name == v then
  			functions.Chat(Msg)

                  return
  		end

            task.wait()
  	end
end
function functions.ChatAll(Msg)
    for i, v in pairs(Bots) do
  		if lp.Name == v then
  			functions.Chat(Msg)
  
  			break
  		end

            task.wait()
  	end
end

function functions.GetPlayer(Username)
      Username = Username:lower()

      for _, player in pairs(Players:GetPlayers()) do
            if player.Name:lower():sub(1, #Username) == Username then
                  return player
            end
      end

      return
end

function functions.load()
      if lp.Name == Master then return end
      
      print("###########################")
      print("###########################")
      print("🔁Loading DefigureBotCTRL...🔁")
      
      task.wait(1)
      
      for _, player in pairs(Players:GetPlayers()) do
            if IsModernChat then
                  TextChatService.OnOutgoingMessage = function(message)
                        Whitelist = getgenv().Data.WhitelistControl
                              
                        if player.Name == Master or table.find(Whitelist, player.Name) then
                              SendCommand(Message, functions)
                        end
                  end
            else
                  player.Chatted:Connect(function(Message)
                        Whitelist = getgenv().Data.WhitelistControl
                                    
                        if player.Name == Master or table.find(Whitelist, player.Name) then
                              SendCommand(Message, functions)
                        end
                  end)
            end
      end
      Players.PlayerAdded:Connect(function(player)
            if IsModernChat then
                  TextChatService.OnOutgoingMessage = function(message)
                        Whitelist = getgenv().Data.WhitelistControl
                              
                        if player.Name == Master or table.find(Whitelist, player.Name) then
                              SendCommand(Message, functions)
                        end
                  end
            else
                  player.Chatted:Connect(function(Message)
                        Whitelist = getgenv().Data.WhitelistControl
                                    
                        if player.Name == Master or table.find(Whitelist, player.Name) then
                              SendCommand(Message, functions)
                        end
                  end)
            end
      end)
      for i, v in pairs(Bots) do
      	if lp.Name == v then
                  if getgenv().Data.ExecuteAnnounce then
                        functions.Chat("DefigureBotCTRL has loaded "..v.." on version "..tostring(version)..". Use "..Prefix.."cmds to view commands")
                        task.wait(0.25)
                        functions.Chat(string.format("[%.2f] bot.isloaded", (tick()-load_start)*1000))
                  end
                  if getgenv().Data.BotCollisions then
                        for _, v in pairs(lp.Character:GetChildren()) do
                              if v:IsA("BasePart") then
                                    v.CanCollide = false
                              end
                        end
                        
                        lp.CharacterAdded:Connect(function(char)
                              for _, v in pairs(char:GetChildren()) do
                                    if v:IsA("BasePart") then
                                          v.CanCollide = false
                                    end
                              end
                        end)
                  end

                  UserSettings():GetService("UserGameSettings").MasterVolume = 0
                  setfpscap(15)
      
      		break
      	end
      end
      
      print("✅Bots Loaded✅")
      print(string.format("[%.2f] functions.load", (tick()-load_start)*1000))
      print("###########################")
      print("###########################")
end

print(string.format("[%.2f] functions.lua", (tick()-load_start)*1000))

return functions
