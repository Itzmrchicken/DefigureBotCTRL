print("Loading commands...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PathFindingService = game:GetService("PathfindingService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

local version = loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzmrchicken/DefigureBotCTRL/refs/heads/main/version.lua"))()

local Bots = getgenv().Data.Bots
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
	["executor"] = "Shows what executor injector is using"
}

return function(Msg, functions)
	local Prefix = getgenv().Data.Prefix
	local Master = getgenv().Data.Master
	
	local Split = Msg:split(" ")
	local Cmd = Split[1]:lower()

	print(Cmd)
	
	if Cmd == Prefix.."chat" then
		local ChatMsg = Msg:gsub(Cmd, "")

		functions.ChatAll(ChatMsg)
	end
	if Cmd == Prefix.."promote" then
		ChatAll("Want the script? Join today, vRQgE5qtUx")
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
				Values.FollowRender = RunService.Heartbeat:Connect(function()
					local UserHRP = UserCharacter and UserCharacter.HumanoidRootPart

					local Character = lp.Character
					local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	
					print(UserHRP.Position)
	
					if not UserHRP or not UserCharacter or not User then warn("User died, left, or random error") Values.Follow = false FollowRender = nil end
	
					Humanoid:MoveTo(UserHRP.Position, UserHRP)
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
				WaypointSpacing = 1,
		})

		for i, v in pairs(Bots) do
			if lp.Name == v then
				print(lp.Name.." has been found")
				Values.AIRender = RunService.Heartbeat:Connect(function()
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
						Humanoid.MoveToFinished:Wait()
					end

					Humanoid.MoveToFinished:Wait()
				end)
			end
		end
	end
	if Cmd == Prefix.."unaifollow" then
		Values.AIFollow = false
		Values.AIFollowTarget = nil

		Values.AIRender = nil
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
		functions.BotChat(1, "Listed commands")
		task.wait(1)
		functions.BotChat(1, "chat, count, gravity, follow, reset, d, rj, swarm, leave, goto, line, dance, nm, define, speed, unfollow, unswarm, und, unaifollow, aifollow, sreset, executor")
	end
	if Cmd == Prefix.."version" then
		functions.BotChat(1, "Current version"..tostring(version))
	end
	if Cmd == Prefix.."whitelist" then
		local Whitelist = getgenv().Data.WhitelistControl
			
		if not Players:FindFirstChild(Split[2]) then
			functions.BotChat(1, "Invalid user, make sure it's the full username and not display name")
			return
		end
		
		if table.find(Whitelist, Split[2]) then
			functions.BotChat(1, "Removing "..Split[2].." from the whitelist")

			table.remove(Whitelist, Split[2])
		else
			functions.BotChat(1, "Adding "..Split[2].." to the whitelist")

			table.insert(Whitelist, Split[2])
		end

		getgenv().Data.WhitelistControl = Whitelist

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
				Values.SwarmRender = RunService.Heartbeat:Connect(function()
					local UserHRP = UserCharacter and UserCharacter.HumanoidRootPart

					local Character = lp.Character
					local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

					print(UserHRP.Position)

					if not UserHRP or not UserCharacter or not User then warn("User died, left, or random error") Values.Swarm = false workspace.Gravity = GlobalValues.Gravity SwarmRender = nil end

					HRP.CFrame = UserHRP.CFrame * CFrame.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10))
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

				HRP.CFrame = UserHRP.CFrame

				break
			end
		end
	end
	if Cmd == Prefix.."line" then
		local User = functions.GetPlayer(Split[2])

		local Spacing = Split[3] or 3

		if Split[2] == "me" then
			User = Players:FindFirstChild(Master)
		end

		Values.LineTarget = User

		Values.Line = Values.LineTarget and true or false

		local UserCharacter = User and User.Character

		for i, v in pairs(Bots) do
			if lp.Name == v then
				print(lp.Name.." has been found")
				Values.LineRender = RunService.Heartbeat:Connect(function()
					local UserHRP = UserCharacter and UserCharacter.HumanoidRootPart

					local Character = lp.Character
					local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

					print(UserHRP.Position)

					if not UserHRP or not UserCharacter or not User then warn("User died, left, or random error") Values.Line = false LineRender = nil end

					local Offset = UserHRP.CFrame.LookVector * (Spacing * table.find(Bots, lp.Name))
					HRP.CFrame = UserHRP.CFrame + Offset
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
		getgenv().Data.Master = Master

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
				Values.DRender = RunService.Heartbeat:Connect(function()
					local UserHRP = UserCharacter and UserCharacter.HumanoidRootPart

					local Character = lp.Character
					local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

					print(UserHRP.Position)

					if not UserHRP or not UserCharacter or not User then warn("User died, left, or random error") Values.D = false DRender = nil end

					local Offset = UserHRP.CFrame.LookVector * (3 * table.find(Bots, lp.Name))
					HRP.CFrame = UserHRP.CFrame * CFrame.new(0, -1, 0) * CFrame.Angles(-math.rad(90), 0, 0) + Offset
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

				Values.FlingRender = RunService.Heartbeat:Connect(function()
					HRP.CFrame = UserHRP.CFrame * CFrame.new(0, 0, math.random(-5, 5))

					if not Values.Fling or not Values.FlingTarget or not UserCharacter then
						workspace.Gravity = GlobalValues.Gravity
						Values.Fling = false
						Values.FlingTarget = nil
						Spin:Destroy()
						-- FlingVal:Destroy()
					end
				end)
			end
		end
	end
	if Cmd == Prefix.."gravity" then
		workspace.Gravity = tonumber(Split[2]) or GlobalValues.Gravity
	end
	if Cmd == Prefix.."anchor" then
		functions.BotChat(1, lp.Character.HumanoidRootPart.Anchored and "Unanchoring bots..." or "Anchoring bots...")
		
		for _, v in pairs(Bots) do
			if lp.Name == v then
				lp.Character.HumanoidRootPart.Anchored = not lp.Character.HumanoidRootPart.Anchored
			end
		end
	end
end
