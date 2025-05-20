print("Loading commands...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local PathFindingService = game:GetService("PathfindingService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

local version = loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzmrchicken/DefigureBotCTRL/refs/heads/main/version.lua"))()

local Bots = getgenv().Data.Bots
local Prefix = getgenv().Data.Prefix
local Master = getgenv().Data.Master

local Values = {
	Follow = false,
	FollowTarget = nil,
	FollowRender = nil,

	AIFollow = false,
	AIFollowTarget = nil,
	AIFollowRender = nil,

	Swarm = false,
	SwarmTarget = nil,
	SwarmRender = nil,

	Line = false,
	LineTarget = nil,
	LineRender = nil,

	D = false,
	DTarget = nil,
	DRender = nil,

	AntiAfk = false,
	AntiAfkRender = nil,

	Orbit = false,
	OrbitTarget = nil,
	OrbitRender = nil,

	Fling = false,
	FlingTarget = nil,
	SpinINST = nil,
	FlingVelINST = nil,
	FlingRender = nil
}
local GlobalValues = {
	Gravity = workspace.Gravity
}
local CommandDef = {
	["chat"] = "Makes the bots chat the provided message. USE: chat {message - nil to reset}",
	["follow"] = "Makes the bots walk towards a provided player. USE: follow {user - nil to reset}",
	["cmds"] = "Shows the list of commands",
	["define"] = "Defines a command. USE: define {command_name}",
	["reset"] = "Resets the bots",
	["rj"] = "Makes the bots rejoin the current server",
	["swarm"] = "Makes the bots buzz around a provided player. USE: swarm {user - nil to reset}",
	["leave"] = "Kicks the bots from the game",
	["goto"] = "Teleports the bots to a provided player. USE: goto {user}",
	["line"] = "Creates a line on a provided player and uses args. USE: line {user - nil to reset} {spacing}",
	["dance"] = "Makes the bots dance. USE: dance {1, 2, 3}",
	["gravity"] = "Sets the bots world gravity. USE: gravity {number}",
	["count"] = "Amount of bots activated",
	["nm"] = "Bot control permissions (perm transfer, cancelled during re-execution)",
	["aifollow"] = "Makes the bots walk and avoid objects towards a provided player. USE: aifollow {user}",
	["sreset"] = "Silently resets the bots",
	["executor"] = "Shows what executor injector is using",
	["version"] = "Script version",
	["fling"] = "Makes the provided user not exist anymore. USE: fling {user}",
	["promote"] = "Promotes the script to others",
	["antiafk"] = "Bots don't get disconnected for idling",
	["orbit"] = "Makes the bots orbit a provided player. USE: orbit {user} {speed} {distant}",
	["prefix"] = "Changes the prefix to run commands"
}

return function(Msg, functions)
	local Split = Msg:split(" ")
	local Cmd = Split[1]:lower()

	print(Cmd)
	
	if Cmd == Prefix.."chat" then
		local ChatMsg = Msg:gsub(Cmd, "")

		functions.ChatAll(ChatMsg)
	end
	if Cmd == Prefix.."prefix" then
		Prefix = Split[2] or Prefix
	end
	if Cmd == Prefix.."promote" then
		functions.ChatAll("Want the script? Join today, vRQgE5qtUx. We have an amazing community. Tutorials on how to use as well!")
	end
	if Cmd == Prefix.."follow" then
		local User = functions.GetPlayer(Split[2])

		if Split[2] == "random" then
			User = Players:GetPlayers()[math.random(1, #Players:GetPlayers())]

			while User.Name ~= lp.Name and task.wait() do
				User = Players:GetPlayers()[math.random(1, #Players:GetPlayers())]
			end
		end
		if Split[2] == "me" then
			User = Players:FindFirstChild(Master)
		end

		Values.FollowTarget = User

		print(User, UserCharacter)

		Values.Follow = Values.FollowTarget and true or false

		local UserCharacter = User and User.Character

		for i, v in pairs(Bots) do
			if lp.Name == v then
				print(lp.Name.." has been found")
				task.spawn(function()
					Values.FollowRender = RunService.Heartbeat:Connect(function()
						UserCharacter = User and User.Character
						local UserHRP = UserCharacter and UserCharacter.HumanoidRootPart
	
						local Character = lp.Character
						local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
		
						print(UserHRP.Position)
	
						if not Values.Follow then workspace.Gravity = GlobalValues.Gravity return end
		
						-- if not UserHRP or not UserCharacter or not User then warn("User died, left, or random error") Values.Follow = false FollowRender = nil end
		
						Humanoid:MoveTo(UserHRP.Position, UserHRP)
					end)
				end)

				break
			end
		end
	end
	if Cmd == Prefix.."orbit" then
		local User = functions.GetPlayer(Split[2])
		local UserCharacter = User and User.Character

		local Speed = Split[3] or 1
		local Radius = Split[4] or 10
		local Spacing = Radius / #Bots
		
		local Rot = 0
		local RotSpeed = math.pi * 2 / Speed

		local CurrentIndex = 0

		Values.OrbitTarget = User
		Values.Orbit = Values.OrbitTarget and true or false

		for i, v in pairs(Bots) do
			if lp.Name == v then
				workspace.Gravity = 0

				CurrentIndex = i
				
				task.spawn(function()
					Values.OrbitRender = RunService.Heartbeat:Connect(function(DeltaTime)
						local UserHRP = UserCharacter and UserCharacter.HumanoidRootPart

						local Character = lp.Character
						local HRP = Character and Character.HumanoidRootPart

						if Values.Orbit == false then workspace.Gravity = GlobalValues.Gravity return end

						Rot = Rot + DeltaTime * RotSpeed

						local Angle = Rot - (CurrentIndex * Spacing)
						local X, Z = math.sin(Angle) * Radius, math.cos(Angle) * Radius

						local NewPos = UserHRP.Position + Vector3.new(X, 0, Z)
						HRP.CFrame = CFrame.new(NewPos, UserHRP.Position)
					end)
				end)

				break
			end
		end
	end
	if Cmd == Prefix.."executor" then
		functions.BotChat(1, "Injected user is using "..tostring(identifyexecutor()))
	end
	if Cmd == Prefix.."aifollow" then
		local User = functions.GetPlayer(Split[2])

		if Split[2] == "me" then
			User = Players:FindFirstChild(Master)
		end

		local UserCharacter = User and User.Character

		Values.AIFollowTarget = User
		Values.AIFollow = Values.AIFollowTarget and true or false

		local NewPath = PathFindingService:CreatePath({
				AgentRadius = 2,
				AgentHeight = 5,
				AgentCanJump = true,
				AgentCanClimb = true,
				-- WaypointSpacing = 1,
		})

		for i, v in pairs(Bots) do
			if lp.Name == v then
				print(lp.Name.." has been found")
				task.spawn(function()
					Values.AIRender = RunService.Heartbeat:Connect(function()
						UserCharacter = User and User.Character
						local UserHRP = UserCharacter and UserCharacter.HumanoidRootPart
	
						local Character = lp.Character
						local HRP = Character and Character.HumanoidRootPart
						local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	
						-- print(UserHRP.Position)
	
						NewPath:ComputeAsync(HRP.Position, UserHRP.Position)
	
						for i, waypoint in pairs(NewPath:GetWaypoints()) do
							if not Values.AIFollow then return end
	
							if waypoint.Action == Enum.PathWaypointAction.Jump then
								Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
							end
								
							Humanoid:MoveTo(waypoint.Position)
							Humanoid.MoveToFinished:Wait(5)
						end
					end)
				end)

				break
			end
		end
	end
	if Cmd == Prefix.."unaifollow" then
		Values.AIFollow = false
		Values.AIFollowTarget = nil

		Values.AIRender = nil
	end
	if Cmd == Prefix.."antiafk" then
		Values.AntiAfk = not Values.AntiAfk

		if Values.AntiAfk then
			for _, v in pairs(Bots) do
				if lp.Name == v then
					Values.AntiAfkRender = lp.Idled:Connect(function()
						VirtualUser:CaptureController()
						VirtualUser:ClickButton2(Vector2.new())
					end)
					
					break
				end
			end
		else
			Values.AntiAfkRender = nil
		end

		functions.BotChat(1, Values.AntiAfk and "Anti-AFK enabled" or "Anti-AFK disable")
	end
	if Cmd == Prefix.."unswarm" then
		Values.Swarm = false
		Values.SwarmTarget = nil

		Values.SwarmRender = nil
		workspace.Gravity = GlobalValues.Gravity
	end
	if Cmd == Prefix.."und" then
		Values.D = false
		Values.DTarget = nil

		Values.DRender = nil
	end
	if Cmd == Prefix.."unfollow" then
		Values.Follow = false
		Values.FollowTarget = nil

		Values.FollowRender = nil
	end
	if Cmd == Prefix.."cmds" then
		local Pages = {
			[1] = {"chat", "count", "antiafk", "follow", "reset", "d", "swarm", "leave", "goto", "line", "dance", "nm"},
			[2] = {"define", "speed", "sreset", "executor", "version", "fling", "whitelist", "aifollow", "unfollow", "unswarm", "und", "unaifollow"},
			[3] = {"orbit", "promote", "cmds", "rj", "gravity", "anchor", "prefix"}
		}
		
		local TotalPages = #Pages
		local Page = tonumber(Split[2]) or 1

		if Pages[Page] then
			functions.BotChat(1, "Listed Commands for Page "..Page)
			task.wait(0.75)

			local Connected_String = ""
			
			for i, command in pairs(Pages[Page]) do
				if i < #Pages[Page] then
					Connected_String = Connected_String.." "..command..","
				else
					Connected_String = Connected_String.." "..command
				end
			end

			functions.BotChat(1, Connected_String)
		elseif Page > TotalPages then
			functions.BotChat(1, "The max page number is "..TotalPages)
		else
			functions.BotChat(1, "An error occured while grabbing that page")
		end
	end
	if Cmd == Prefix.."version" then
		local liveversion = loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzmrchicken/DefigureBotCTRL/refs/heads/main/version.lua"))()
		
		functions.BotChat(1, "Current version is "..tostring(version)..". This version is "..(version == liveversion and "up to date" or "outdated"))
	end
	if Cmd == Prefix.."whitelist" then
		local Whitelist = getgenv().Data.WhitelistControl

		local User = functions.GetPlayer(Split[2])
			
		if not User then
			functions.BotChat(1, "Invalid user, make sure it's the full username and not display name")
			return
		end
		
		if table.find(Whitelist, User.Name) then
			functions.BotChat(1, "Removing "..User.Name.." from the whitelist...")

			table.remove(Whitelist, table.find(Whitelist, User.Name))
				
			functions.BotChat(1, User.Name.." your permissions have been revoked!")
		else
			functions.BotChat(1, "Adding "..User.Name.." to the whitelist...")

			table.insert(Whitelist, User.Name)

			
			functions.BotChat(1, User.Name.." you now have permissions to use commands! Do "..Prefix.."cmds to view commands!")
		end

		-- getgenv().Data.WhitelistControl = Whitelist

		task.wait(1)
		functions.BotChat(1, "!clear")
	end
	if Cmd == Prefix.."reset" then
		functions.ChatAll("Resetting...")

		for i, v in pairs(Bots) do
			if lp.Name == v then
				lp.Character.Humanoid.Health = 0

				break
			end
		end
	end
	if Cmd == Prefix.."sreset" then
		for i, v in pairs(Bots) do
			if lp.Name == v then
				lp.Character.Humanoid.Health = 0

				break
			end
		end
	end
	if Cmd == Prefix.."rj" then
		local TPS = game:GetService("TeleportService")

		functions.ChatAll("Rejoining...")

		task.wait(math.random(1, 2.5))

		for i, v in pairs(Bots) do
			if lp.Name == v then
				TPS:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)

				break
			end

			task.wait()
		end
	end
	if Cmd == Prefix.."swarm" then
		local User = functions.GetPlayer(Split[2])

		if Split[2] == "random" then
			User = Players:GetPlayers()[math.random(1, #Players:GetPlayers())]

			while User.Name ~= lp.Name and task.wait() do
				User = Players:GetPlayers()[math.random(1, #Players:GetPlayers())]
			end
		end

		if Split[2] == "me" then
			User = Players:FindFirstChild(Master)
		end

		Values.SwarmTarget = User

		Values.Swarm = Values.SwarmTarget and true or false

		local UserCharacter = User and User.Character

		for i, v in pairs(Bots) do
			if lp.Name == v then
				print(lp.Name.." has been found")
				workspace.Gravity = 0
				task.spawn(function()
					Values.SwarmRender = RunService.Heartbeat:Connect(function()
						local UserHRP = UserCharacter and UserCharacter.HumanoidRootPart
	
						local Character = lp.Character
						local HRP = Character and Character:FindFirstChild("HumanoidRootPart")
	
						if not Values.Swarm or UserCharacter.Humanoid.Health <= 0 then return end
	
						print(UserHRP.Position)
	
						-- if not UserHRP or not UserCharacter or not User then warn("User died, left, or random error") Values.Swarm = false workspace.Gravity = GlobalValues.Gravity SwarmRender = nil end
	
						HRP.CFrame = UserHRP.CFrame * CFrame.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10))
					end)
				end)

				break
			end
		end
	end
	if Cmd == Prefix.."leave" then
		functions.BotChat(1, "Leaving the game...")

		task.wait(1)

		for i, v in pairs(Bots) do
			if lp.Name == v then
				lp:Kick("Master kicked bots")

				break
			end
		end
	end
	if Cmd == Prefix.."goto" then
		local User = functions.GetPlayer(Split[2])

		if Split[2] == "me" then
			User = Players:FindFirstChild(Master)
		end

		local UserCharacter = User and User.Character
		local UserHRP = UserCharacter and UserCharacter.HumanoidRootPart

		for i, v in pairs(Bots) do
			if lp.Name == v then
				local Character = lp.Character
				local HRP = Character and Character.HumanoidRootPart

				if not HRP then return functions.BotChat(1, "This user doesn't exist or an error occured") end

				HRP.CFrame = UserHRP.CFrame

				break
			end
		end
	end
	if Cmd == Prefix.."line" then
		local User = functions.GetPlayer(Split[2])

		local Spacing = tonumber(Split[3]) or 3

		if Split[2] == "me" then
			User = Players:FindFirstChild(Master)
		end

		Values.LineTarget = User

		Values.Line = Values.LineTarget and true or false

		local UserCharacter = User and User.Character

		for i, v in pairs(Bots) do
			if lp.Name == v then
				print(lp.Name.." has been found")
				task.spawn(function()
					Values.LineRender = RunService.Heartbeat:Connect(function()
						local UserHRP = UserCharacter and UserCharacter.HumanoidRootPart
	
						local Character = lp.Character
						local HRP = Character and Character:FindFirstChild("HumanoidRootPart")
	
						if not Values.Line or UserCharacter.Humanoid.Health <= 0 then return end
	
						print(UserHRP.Position)
	
						-- if not UserHRP or not UserCharacter or not User then warn("User died, left, or random error") Values.Line = false LineRender = nil end
	
						local Offset = UserHRP.CFrame.LookVector * (Spacing * table.find(Bots, lp.Name))
						HRP.CFrame = UserHRP.CFrame + Offset
					end)
				end)

				break
			end
		end
	end
	if Cmd == Prefix.."dance" then
		local DanceType = "/e dance"..(Split[2] or math.random(1, 3))

		functions.ChatAll(DanceType)
	end
	if Cmd == Prefix.."nm" then
		local User = functions.GetPlayer(Split[2])

		-- if not User then return functions.ChatAll(Split[2], " isn't a valid user") end

		functions.BotChat(1, "Changing masters...")
		
		Master = User.Name

		functions.BotChat(1, Master.." is the new master, do .cmds to view commands")
		functions.BotChat(1, "!clear")
	end
	if Cmd == Prefix.."define" then
		local CmdDef = CommandDef[Split[2]]

		if not CmdDef then return functions.BotChat(1, "Looks like that's an invalid command, try again!") end

		functions.BotChat(1, CmdDef)
	end
	if Cmd == Prefix.."d" then
		local User = functions.GetPlayer(Split[2])

		if Split[2] == "me" then
			User = Players:FindFirstChild(Master)
		end

		Values.DTarget = User

		Values.D = Values.DTarget and true or false

		local UserCharacter = User and User.Character

		for i, v in pairs(Bots) do
			if lp.Name == v then
				print(lp.Name.." has been found")
				task.spawn(function()
					Values.DRender = RunService.Heartbeat:Connect(function()
						local UserHRP = UserCharacter and UserCharacter.HumanoidRootPart
	
						local Character = lp.Character
						local HRP = Character and Character:FindFirstChild("HumanoidRootPart")
	
						if not Values.D or UserCharacter.Humanoid.Health <= 0 then return end
	
						print(UserHRP.Position)
	
						-- if not UserHRP or not UserCharacter or not User then warn("User died, left, or random error") Values.D = false DRender = nil end
	
						local Offset = UserHRP.CFrame.LookVector * (3 * table.find(Bots, lp.Name))
						HRP.CFrame = UserHRP.CFrame * CFrame.new(0, -1, 0) * CFrame.Angles(-math.rad(90), 0, 0) + Offset
					end)
				end)

				break
			end
		end
	end
	if Cmd == Prefix.."speed" then
		for i, v in pairs(Bots) do
			if lp.Name == v then
				lp.Character.Humanoid.WalkSpeed = Split[2] or 16

				break
			end
		end
	end
	if Cmd == Prefix.."count" then
		local InGame = 0

		for _, v in pairs(Bots) do
			if Players:FindFirstChild(v) then
				InGame += 1
			end
		end

		functions.BotChat(1, "The current bot count is "..InGame)
	end
	if Cmd == Prefix.."fling" then
		local User = functions.GetPlayer(Split[2])

		local UserCharacter = User and User.Character
		local UserHRP = UserCharacter and UserCharacter.HumanoidRootPart

		Values.FlingTarget = User

		Values.Fling = Values.FlingTarget and true or false

		for i, v in pairs(Bots) do
			if lp.Name == v then
				workspace.Gravity = 0

				local Character = lp.Character
				local HRP = Character and Character.HumanoidRootPart

				local Spin = Instance.new("BodyAngularVelocity")
				Spin.Name = "Fling"
				Spin.Parent = HRP
				Spin.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
				Spin.AngularVelocity = Vector3.new(9999, 9999, 9999)

				-- local FlingVal = Instance.new("BodyVelocity")
				-- FlingVel.Name = "FlingVel"
				-- FlingVel.Parent = HRP
				-- FlingVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
				-- FlingVel.Velocity = Vector3.new(250, 250, 250)

				if not Values.Fling or not Values.FlingTarget then
					workspace.Gravity = GlobalValues.Gravity
					Values.Fling = false
					Spin:Destroy()
					-- FlingVal:Destroy()
				end

				for _, v in pairs(UserCharacter:GetChildren()) do
					if v:IsA("BasePart") then
						v.CanCollide = false
					end
				end

				task.spawn(function()
					Values.FlingRender = RunService.Heartbeat:Connect(function()
						-- if not UserHRP then
						-- 	workspace.Gravity = GlobalValues.Gravity
						-- 	Values.Fling = false
						-- 	Values.FlingTarget = nil
						-- 	Spin:Destroy()
						-- end
								
						HRP.CFrame = UserHRP.CFrame * CFrame.new(0, 0, math.random(-10, 10))
	
						if not Values.Fling or not Values.FlingTarget or UserCharacter.Humanoid.Health <= 0 then
							workspace.Gravity = GlobalValues.Gravity
							Values.Fling = false
							Values.FlingTarget = nil
							Spin:Destroy()
							-- FlingVal:Destroy()
						end
					end)
				end)

				break
			end
		end
	end
	if Cmd == Prefix.."gravity" then
		if table.find(Bots, lp.Name) then workspace.Gravity = tonumber(Split[2]) or GlobalValues.Gravity end
	end
	if Cmd == Prefix.."anchor" then
		functions.BotChat(1, lp.Character.HumanoidRootPart.Anchored and "Unanchoring bots..." or "Anchoring bots...")
		
		for _, v in pairs(Bots) do
			if lp.Name == v then
				lp.Character.HumanoidRootPart.Anchored = not lp.Character.HumanoidRootPart.Anchored

				break
			end

			task.wait()
		end
	end
end
