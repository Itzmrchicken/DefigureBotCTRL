local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

local Bots = getgenv().Data.Bots
local Values = {
	Follow = false,
	FollowTarget = nil,

	Swarm = false,
	SwarmTarget = nil,

	Line = false,
	LineTarget = nil,

	D = false,
	DTarget = nil,

	Fling = false,
	FlingTarget = nil,
	SpinINST = nil,
	FlingVelINST = nil
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
}

print("Before")
-- local functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/Itzmrchicken/DefigureBotCTRL/refs/heads/main/functions.lua"))()
print("After")

local Prefix = getgenv().Data.Prefix
local Master = getgenv().Data.Master

return function(Msg)
	local Split = Msg:split(" ")
	local Cmd = Split[1]:lower()

	-- print(Cmd)
	
	if Cmd == Prefix.."chat" then
		local ChatMsg = Msg:gsub(Cmd, "")

		functions.ChatAll(ChatMsg)
	end
	if Cmd == Prefix.."follow" then
		local User = Players:FindFirstChild(Split[2])

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
				while (Values.Follow and Values.FollowTarget) and task.wait(1) do
					local UserHRP = UserCharacter and UserCharacter.HumanoidRootPart

					local Character = lp.Character
					local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

					print(UserHRP.Position)

					if not UserHRP or not UserCharacter or not User then warn("User died, left, or random error") Values.Follow = false break end

					Humanoid:MoveTo(UserHRP.Position, UserHRP)
				end

				break
			end
		end
	end
	if Cmd == Prefix.."unswarm" then
		Values.Swarm = false
		Values.SwarmTarget = nil

		workspace.Gravity = GlobalValues.Gravity
	end
	if Cmd == Prefix.."und" then
		Values.D = false
		Values.DTarget = nil
	end
	if Cmd == Prefix.."unfollow" then
		Values.Follow = false
		Values.FollowTarget = nil
	end
	if Cmd == Prefix.."cmds" then
		functions.BotChat(1, "Listed commands")
		task.wait(1)
		functions.BotChat(1, "chat, count, gravity, follow, reset, d, rj, swarm, leave, goto, line, dance, nm, define, speed, unfollow, unswarm, und")
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
	if Cmd == Prefix.."rj" then
		local TPS = game:GetService("TeleportService")

		functions.ChatAll("Rejoining...")

		task.wait(math.random(0, 2.5))

		for i, v in pairs(Bots) do
			if lp.Name == v then
				TPS:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)

				break
			end
		end
	end
	if Cmd == Prefix.."swarm" then
		local User = Players:FindFirstChild(Split[2])

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
				while (Values.Swarm and Values.SwarmTarget) and task.wait() do
					local UserHRP = UserCharacter and UserCharacter.HumanoidRootPart

					local Character = lp.Character
					local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

					print(UserHRP.Position)

					if not UserHRP or not UserCharacter or not User then warn("User died, left, or random error") Values.Swarm = false workspace.Gravity = GlobalValues.Gravity break end

					HRP.CFrame = UserHRP.CFrame * CFrame.new(math.random(-10, 10), math.random(-10, 10), math.random(-10, 10))
				end

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
		local User = Players:FindFirstChild(Split[2])

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
		local User = Players:FindFirstChild(Split[2])

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
				while (Values.Line and Values.LineTarget) and task.wait() do
					local UserHRP = UserCharacter and UserCharacter.HumanoidRootPart

					local Character = lp.Character
					local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

					print(UserHRP.Position)

					if not UserHRP or not UserCharacter or not User then warn("User died, left, or random error") Values.Line = false break end

					local Offset = UserHRP.CFrame.LookVector * (Spacing * table.find(Bots, lp.Name))
					HRP.CFrame = UserHRP.CFrame + Offset
				end

				break
			end
		end
	end
	if Cmd == Prefix.."dance" then
		local DanceType = "/e dance"..(Split[2] or math.random(1, 3))

		functions.ChatAll(DanceType)
	end
	if Cmd == Prefix.."nm" then
		local User = Players:FindFirstChild(Split[2])

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
		local User = Players:FindFirstChild(Split[2])

		if Split[2] == "me" then
			User = Players:FindFirstChild(Master)
		end

		Values.DTarget = User

		Values.D = Values.DTarget and true or false

		local UserCharacter = User and User.Character

		for i, v in pairs(Bots) do
			if lp.Name == v then
				print(lp.Name.." has been found")
				while (Values.D and Values.DTarget) and task.wait() do
					local UserHRP = UserCharacter and UserCharacter.HumanoidRootPart

					local Character = lp.Character
					local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

					print(UserHRP.Position)

					if not UserHRP or not UserCharacter or not User then warn("User died, left, or random error") Values.D = false break end

					local Offset = UserHRP.CFrame.LookVector * (3 * table.find(Bots, lp.Name))
					HRP.CFrame = UserHRP.CFrame * CFrame.new(0, -1, 0) * CFrame.Angles(-math.rad(90), 0, 0) + Offset
				end

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
		local User = Players:FindFirstChild(Split[2])

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

				while (Values.Fling and Values.FlingTarget) and task.wait() do
					HRP.CFrame = UserHRP.CFrame * CFrame.new(0, math.random(-3, 3), 0)

					if not Values.Fling or not Values.FlingTarget or not UserCharacter then
						workspace.Gravity = GlobalValues.Gravity
						Values.Fling = false
						Values.FlingTarget = nil
						Spin:Destroy()
						-- FlingVal:Destroy()
					end
				end
			end
		end
	end
	if Cmd == Prefix.."gravity" then
		workspace.Gravity = tonumber(Split[2]) or GlobalValues.Gravity
	end
end
