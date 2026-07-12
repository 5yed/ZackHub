------------------------------------
-- LIBRARY SETUP
------------------------------------
local Library = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Library:CreateWindow({
   Name = "ZackHub",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "ZackHub Interface Suite",
   LoadingSubtitle = "by 5yed.A",
   ShowText = "ZackHub", -- for mobile users to unhide Rayfield, change if you'd like
   Theme = "DarkBlue", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "P", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from emitting warnings when the script has a version mismatch with the interface.

   -- ScriptID = "sid_xxxxxxxxxxxx", -- Your Script ID from developer.sirius.menu — enables analytics, managed keys, and script hosting

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Zack Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include Discord.gg/. E.g. Discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the Discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique, as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that the system will accept, can be RAW file links (pastebin, github, etc.) or simple strings ("hello", "key22")
   }
})

-----------------------------------------------
-- FUNCTIONS
-----------------------------------------------

-- REFUEL FUNCTION
local function AutoRefuelFunction(Value)
    if not Value then
        return
    end

    local userId = game.Players.LocalPlayer.UserId
    local found = false

    for _, vehicle in ipairs(workspace.Vehicles:GetChildren()) do
        if vehicle:GetAttribute("OwnerUserId") == userId then
            found = true

            local fuel = vehicle:GetAttribute("CurrentFuel")

            if fuel and fuel <= 0 then
                vehicle:SetAttribute("CurrentFuel", 100)
            end

            break
        end
    end

    if not found then
        warn("No vehicle found for UserId:", userId)
    end
end

-- BETTER GATES FUNCTION
local BetterGatesApplied = false

local function BetterGatesFunction()
	if BetterGatesApplied then
		Library:Notify({
			Title = "Better Gates",
			Content = "Already applied.",
			Duration = 6.5,
			Image = 4483362458,
		})
		return
	end

	local gatesFolder = workspace:WaitForChild("Gates")

	local triggerSuccess, triggerFail = 0, 0
	local promptSuccess, promptFail = 0, 0
	local highlightSuccess, highlightFail = 0, 0


	for _, gate in ipairs(gatesFolder:GetChildren()) do
		if gate.Name == "Gate" then

			local triggerResult = pcall(function()
				local trigger = gate:FindFirstChild("Trigger")

				if not trigger or not trigger:IsA("BasePart") then
					error("No Trigger found")
				end

				trigger.Size = trigger.Size + Vector3.new(200, 0, 200)
			end)

			if triggerResult then
				triggerSuccess += 1
			else
				triggerFail += 1
			end

			local hasPrompt = false

			local promptResult = pcall(function()
				for _, descendant in ipairs(gate:GetDescendants()) do
					if descendant:IsA("ProximityPrompt") then
						descendant.MaxActivationDistance = 150
						hasPrompt = true
					end
				end

				if not hasPrompt then
					error("No ProximityPrompt found")
				end
			end)

			if promptResult then
				promptSuccess += 1
			else
				promptFail += 1
			end

			if hasPrompt then
				local highlightResult = pcall(function()
					if not gate:FindFirstChild("GateHighlight") then
						local highlight = Instance.new("Highlight")

						highlight.Name = "GateHighlight"
						highlight.FillColor = Color3.fromRGB(120, 80, 255)
						highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
						highlight.FillTransparency = 0.5
						highlight.OutlineTransparency = 0
						highlight.Parent = gate
					end
				end)

				if highlightResult then
					highlightSuccess += 1
				else
					highlightFail += 1
				end
			else
				highlightFail += 1
			end
		end
	end

	Library:Notify({
		Title = "Trigger Results",
		Content = string.format(
			"Success: %d\nFailed: %d",
			triggerSuccess,
			triggerFail
		),
		Duration = 6.5,
		Image = 4483362458,
	})

	Library:Notify({
		Title = "Prompt Results",
		Content = string.format(
			"Success: %d\nFailed: %d",
			promptSuccess,
			promptFail
		),
		Duration = 6.5,
		Image = 4483362458,
	})

	Library:Notify({
		Title = "Highlight Results",
		Content = string.format(
			"Success: %d\nFailed: %d",
			highlightSuccess,
			highlightFail
		),
		Duration = 6.5,
		Image = 4483362458,
	})

	BetterGatesApplied = true

	Library:Notify({
		Title = "Better Gates Finished",
		Content = "Gate modifications completed.",
		Duration = 6.5,
		Image = 4483362458,
	})
end

-- INIFINITE YIELD FUNCTION
local InfiniteYieldLoaded = false

local function InfiniteYieldFunction()
	if InfiniteYieldLoaded then
		Library:Notify({
			Title = "Infinite Yield",
			Content = "Infinite Yield is already loaded.",
			Duration = 6.5,
			Image = 4483362458,
		})
		return
	end

	InfiniteYieldLoaded = true

	loadstring(game:HttpGet(
		"https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"
	))()

	Library:Notify({
		Title = "Infinite Yield",
		Content = "Infinite Yield loaded successfully.",
		Duration = 6.5,
		Image = 4483362458,
	})
end

-----------------------------------------------
-- GROUP SYSTEM
-----------------------------------------------

local Group1Side = Vector3.new(6716.88, 17.05, 142.88)
local Group2Side = Vector3.new(-132.61, 17.05, 142.77)

local Locations = {
	-- Group 2
	["Smuggler 1"] = CFrame.new(-201.39, 17.01, 1244.04),
	["Smuggler 2"] = CFrame.new(208.26, 17.07, -46.06),
	["Jewelry"] = CFrame.new(-75.03, 18.45, 926.13),
	["Bank"] = CFrame.new(-286.19, 17.05, -252.29),
	["Safe Spot"] = CFrame.new(-200.45, 132.86, 230.38),

	-- Group 1
	["Buy Jewelry"] = CFrame.new(6821.61, 17.24, 22.11),
	["Launder"] = CFrame.new(6809.25, 17.27, -34.69),
	["Buy Crowbar"] = CFrame.new(6806.12, 17.24, -7.75),
}

local Group1Set = {
	["Buy Jewelry"] = true,
	["Launder"] = true,
	["Buy Crowbar"] = true,
}

-----------------------------------------------
-- CAR TELEPORT SYSTEM
-----------------------------------------------
local STEP_SIZE = 900
local HEIGHT_ABOVE_GROUND = 8
local WAIT_BETWEEN_JUMPS = 2

local function getOwnedVehicle()
	local vehicles = workspace:FindFirstChild("Vehicles")

	if not vehicles then
		return nil
	end

	for _, vehicle in ipairs(vehicles:GetChildren()) do
		if vehicle:GetAttribute("OwnerUserId") == game.Players.LocalPlayer.UserId then
			return vehicle
		end
	end
end


local function getGroundPosition(position, ignore)
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Blacklist
	params.FilterDescendantsInstances = {ignore}

	local result = workspace:Raycast(
		position + Vector3.new(0,500,0),
		Vector3.new(0,-1000,0),
		params
	)

	if result then
		return Vector3.new(
			position.X,
			result.Position.Y + HEIGHT_ABOVE_GROUND,
			position.Z
		)
	end

	return position + Vector3.new(0,HEIGHT_ABOVE_GROUND,0)
end

local function CarTeleport(target)
	local vehicle = getOwnedVehicle()

	if not vehicle then
		Library:Notify({
			Title = "Car Teleport",
			Content = "No owned vehicle found.",
			Duration = 5,
			Image = 4483362458,
		})
		return
	end

	TeleportCancelled = false

	task.spawn(function()

		while true do
			if TeleportCancelled then
				local current = vehicle:GetPivot().Position
				if not vehicle or not vehicle.Parent then
					return "FAILED"
				end

				if vehicle:GetAttribute("CurrentFuel") <= 0 then
					return "FAILED"
				end
				local safe = getGroundPosition(current, vehicle)

				vehicle:PivotTo(CFrame.new(safe))

				return
			end

			local current = vehicle:GetPivot().Position
			local destination = target.Position

			local offset = destination - current
			local distance = offset.Magnitude

			if distance <= STEP_SIZE then
				local final = getGroundPosition(destination, vehicle)
				vehicle:PivotTo(CFrame.new(final))
				return
			end

			local nextPosition = current + offset.Unit * STEP_SIZE
			nextPosition = getGroundPosition(nextPosition, vehicle)

			vehicle:PivotTo(CFrame.new(nextPosition))

			if not LastVehiclePos then
				LastVehiclePos = vehicle:GetPivot().Position
				StuckTime = 0
			end

			local moved = (vehicle:GetPivot().Position - LastVehiclePos).Magnitude

			if moved < 2 then
				StuckTime += WAIT_BETWEEN_JUMPS
			else
				LastVehiclePos = vehicle:GetPivot().Position
				StuckTime = 0
			end

			if StuckTime >= 8 then
				return "FAILED"
			end
			task.wait(WAIT_BETWEEN_JUMPS)

		end

	end)
end

-----------------------------------------------
-- PLAYER MOVEMENT SYSTEM
-----------------------------------------------
local function moveTo(pos)
	local root = getRoot()

	while not cancelTeleport do
		local delta = pos - root.Position
		local dist = delta.Magnitude

		if dist < 3 then
			break
		end

		root.CFrame = CFrame.new(root.Position + delta.Unit * math.min(1.5, dist))
		RunService.Heartbeat:Wait()
	end
end

-- HIGHWAY ROUTE
local function isInGroup1(pos)
	return pos.X > 3000
end

local function travel(targetName, targetCF)
	if isTeleporting then return end
	isTeleporting = true
	cancelTeleport = false

	local root = getRoot()
	local targetPos = targetCF.Position

	local inGroup1 = isInGroup1(root.Position)
	local targetGroup1 = Group1Set[targetName] == true

	-- CASE 1: Already in correct group → SKIP HIGHWAY
	if inGroup1 == targetGroup1 then
		moveTo(targetPos)
		isTeleporting = false
		return
	end

	-- CASE 2: Wrong group → use highway
	if inGroup1 then
		moveTo(Group1Side)
	else
		moveTo(Group2Side)
	end

	if inGroup1 then
		moveTo(Group2Side)
	else
		moveTo(Group1Side)
	end

	moveTo(targetPos)

	isTeleporting = false
end

-----------------------------------------------
-- AUTO GRINDER SYSTEM
-----------------------------------------------
local AutoGrinderRunning = false
local AutoGrinderThread = nil
local TeleportCancelled = false
LastVehiclePos = nil
StuckTime = 0

local GrinderRoute = {
    {
        Name = "Buy Jewelry",
        CF = Locations["Buy Jewelry"]
    },
    {
        Name = "Smuggler 1",
        CF = Locations["Smuggler 1"]
    },
    {
        Name = "Launder",
        CF = Locations["Launder"]
    }
}


local function StopAutoGrinder()
	AutoGrinderRunning = false

	-- Stop active teleport immediately
	TeleportCancelled = true

	if AutoGrinderThread then
		task.cancel(AutoGrinderThread)
		AutoGrinderThread = nil
	end

	-- Put car safely above ground
	local vehicle = getOwnedVehicle()

	if vehicle then
		local current = vehicle:GetPivot().Position
		local safePosition = getGroundPosition(current, vehicle)

		vehicle:PivotTo(CFrame.new(safePosition))

	end

	Library:Notify({
		Title = "Auto Grinder",
		Content = "Stopped safely.",
		Duration = 3,
		Image = 4483362458,
	})

end

local function AutoGrinderFunction(Value)
	if not Value then
        if AutoGrinderRunning then
            StopAutoGrinder()
        end
        return
    end

	if AutoGrinderThread then
		return
	end

	AutoGrinderRunning = true

	AutoGrinderThread = task.spawn(function()

		Library:Notify({
			Title = "Auto Grinder",
			Content = "Started.",
			Duration = 3,
			Image = 4483362458,
		})

		while AutoGrinderRunning do

			for _, target in ipairs(GrinderRoute) do

				CurrentTarget = target.CF
				CurrentName = target.Name

				if not AutoGrinderRunning then
					break
				end


				local result = CarTeleport(target.CF)

				if result == "FAILED" then
					travel(target.Name, target.CF)
				end


				-- Allow teleport to complete
				local vehicle = getOwnedVehicle()

				if vehicle then

					repeat
						task.wait(0.25)

						local distance =
							(vehicle:GetPivot().Position - target.CF.Position).Magnitude

					until distance < 10 or not AutoGrinderRunning

				-- Give the car a moment to settle near the prompt
				task.wait(1)
				
				if target.Name == "Buy Jewelry" then
					local prompt = workspace.WorldBuyableItems["Fake Diamond Ring"].Handle.PromptAttachment.ProximityPrompt
				
					for i = 1, 5 do
						fireproximityprompt(prompt)
						task.wait(0.2)
					end
				
				elseif target.Name == "Smuggler 1" then
					local prompt = workspace.NPC.Seller3.HumanoidRootPart.SellSmuggledGoodsPrompt
					fireproximityprompt(prompt)
					task.wait(1)
				
				elseif target.Name == "Launder" then
					local prompt = workspace.LaunderPrompts.LaunderTrigger.PromptPart.LaunderBriefcasePrompt
					fireproximityprompt(prompt)
					task.wait(1)
				end
				end
			end
		end

		AutoGrinderThread = nil
	end)
end

-----------------------------------------------
-- BOX JOB
-----------------------------------------------
local BoxJobEnabled = false
local BoxJobThread

local function RunBoxJob(Value)
    BoxJobEnabled = Value

    if not BoxJobEnabled then
        return
    end

    if BoxJobThread then
        return
    end

    BoxJobThread = task.spawn(function()
        local player = game:GetService("Players").LocalPlayer

        while BoxJobEnabled do
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart")

            local FetchPrompt = workspace.BoxJob.PromptParts.FetchPromptPart.BoxFetchPrompt
            local DeliverPrompt = workspace.BoxJob.PromptParts.DeliverPromptPart.BoxDeliverPrompt

            FetchPrompt.HoldDuration = 0
            FetchPrompt.MaxActivationDistance = 100

            DeliverPrompt.HoldDuration = 0
            DeliverPrompt.MaxActivationDistance = 100

            hrp.CFrame = CFrame.new(-15, 18.095733642578125, -70)
            task.wait(0.4)
            fireproximityprompt(FetchPrompt)

            hrp.CFrame = CFrame.new(5, 16.463029861450195, -55)
            task.wait(0.4)
            fireproximityprompt(DeliverPrompt)

            task.wait(0.1)
        end

        BoxJobThread = nil
    end)
end

--------------------------------------------------
-- REMOVE BLACK MARKET
--------------------------------------------------
local function DestroyBlackMarket()
	local blackMarket = workspace:FindFirstChild("BlackMarket")
	
	if blackMarket then
	    blackMarket:Destroy()
	end
end

--------------------------------------------------
-- REMOVE BORDER SPEED LIMIT AND PARKING RESTRICTORS
--------------------------------------------------
local BorderLimitWatcherStarted = false

local function RemoveBorderLimits()
	if BorderLimitWatcherStarted then
		return
	end
	BorderLimitWatcherStarted = true

	local gameRegions = workspace:WaitForChild("GameRegions")
	local deletedParts = {}

	local function tryDelete(obj)
		if obj:IsA("Part") and obj.Name == "BorderSpeedLimitRegion" and not deletedParts[obj] then
			deletedParts[obj] = true
			obj:Destroy()
		end
	end

	local function scan()
		for _, obj in ipairs(gameRegions:GetDescendants()) do
			tryDelete(obj)
		end

		local parkingRestrictors = workspace:FindFirstChild("ParkingRestrictors")
		if parkingRestrictors then
			parkingRestrictors:Destroy()
		end
	end
	
	scan()
	gameRegions.DescendantAdded:Connect(tryDelete)

	task.spawn(function()
		while true do
			task.wait(300)
			scan()
		end
	end)

	Library:Notify({
		Title = "Border Limits & Parking Restrictors",
		Content = "Successfully Removed.",
		Duration = 6.5,
		Image = 4483362458,
	})
end

local LowLagApplied = false
local VehicleWatcherConnection

local function removeVehicleWheels(vehicle)
	if vehicle:GetAttribute("OwnerUserId") ~= game.Players.LocalPlayer.UserId then
		return
	end

	local wheels = vehicle:FindFirstChild("Wheels")
	if wheels then
		wheels:Destroy()
	end
end

local function LowLagFunction()
	if LowLagApplied then
		return
	end
	LowLagApplied = true
    for i = 1, 3 do
        game.Players.LocalPlayer.Character:PivotTo(Locations["Smuggler 1"])
        task.wait(0.5)
    end

	-- Remove textures and decals
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Texture") or obj:IsA("Decal") then
			obj:Destroy()
		end
	end

	-- Remove workspace objects
	for _, name in ipairs({
		"Gates",
		"Scanners",
		"TacoHellPuddles",
		"Tunnel",
		"BorderSigns",
	}) do
		local obj = workspace:FindFirstChild(name)
		if obj then
			obj:Destroy()
		end
	end

	-- Remove workspace.Map.Models.Model
	local map = workspace:FindFirstChild("Map")
	if map then
		local models = map:FindFirstChild("Models")
		if models then
			local model = models:FindFirstChild("Model")
			if model then
				model:Destroy()
			end
		end
	end

	-- Improve prompts
	local prompts = {
		workspace.LaunderPrompts.LaunderTrigger.PromptPart:FindFirstChild("LaunderBriefcasePrompt"),
		workspace.WorldBuyableItems["Fake Diamond Ring"].Handle.PromptAttachment:FindFirstChild("ProximityPrompt"),
		workspace.NPC.Seller3.HumanoidRootPart:FindFirstChild("SellSmuggledGoodsPrompt"),
	}

	for _, prompt in ipairs(prompts) do
		if prompt then
			prompt.MaxActivationDistance = 150
			prompt.HoldDuration = 0
		end
	end

	-- Remove world buyable items except Crowbar and Fake Diamond Ring
	local worldBuyableItems = workspace:WaitForChild("WorldBuyableItems")

    for _, item in ipairs(worldBuyableItems:GetChildren()) do
        if item.Name ~= "Crowbar" and item.Name ~= "Fake Diamond Ring" then
            print("Destroying:", item.Name)
            item:Destroy()
        end
    end

	-- Remove wheels from existing vehicles
	local vehicles = workspace:WaitForChild("Vehicles")

	for _, vehicle in ipairs(vehicles:GetChildren()) do
		removeVehicleWheels(vehicle)
	end

	-- Remove wheels from future vehicles
	if not VehicleWatcherConnection then
		VehicleWatcherConnection = vehicles.ChildAdded:Connect(function(vehicle)
			task.wait(0.5)
			removeVehicleWheels(vehicle)
		end)
	end

	Library:Notify({
		Title = "Low Lag",
		Content = "Low lag mode applied.",
		Duration = 5,
		Image = 4483362458,
	})
end
-----------------------------------------------
-- UI SETUP
-----------------------------------------------
Library:Notify({
   Title = "ZachHub",
   Content = "Use 'Z' to hide/unhide the UI.",
   Duration = 5,
   Image = 4483362458,
})

-----------------------------------------------
-- AUTOFARM SECTION
-----------------------------------------------

local Autofarm = Window:CreateTab("Autofarm", 4483362458)

-----------------------------------------------
-- AUTO GRINDER SECTION
-----------------------------------------------
local GrinderSection = Autofarm:CreateSection("Auto Grinder")

Autofarm:CreateToggle({
	Name = "Auto Grinder",
	CurrentValue = false,
	Flag = "AutoGrinder",
	Callback = function(Value)
		AutoGrinderFunction(Value)
	end
})

Autofarm:CreateToggle({
    Name = "Farm Box Job",
    CurrentValue = false,
    Flag = "BoxFarm",
    Callback = function(Value)
        RunBoxJob(Value)
    end
})

local SettingsSection = Autofarm:CreateSection("Teleport Settings")

Autofarm:CreateSlider({
	Name = "Step Size",
	Range = {100,10000},
	Increment = 100,
	Suffix = " studs",
	CurrentValue = STEP_SIZE,
	Flag = "StepSize",
	Callback = function(Value)
		STEP_SIZE = Value
	end,
})


Autofarm:CreateSlider({
	Name = "Height Above Ground",
	Range = {1,50},
	Increment = 1,
	Suffix = " studs",
	CurrentValue = HEIGHT_ABOVE_GROUND,
	Flag = "HeightGround",
	Callback = function(Value)
		HEIGHT_ABOVE_GROUND = Value
	end,
})


Autofarm:CreateSlider({
	Name = "Wait Between Jumps",
	Range = {0,5},
	Increment = 0.1,
	Suffix = " seconds",
	CurrentValue = WAIT_BETWEEN_JUMPS,
	Flag = "WaitJumps",
	Callback = function(Value)
		WAIT_BETWEEN_JUMPS = Value
	end,
})

local TeleportSection = Autofarm:CreateSection("Teleport Locations")
for name, location in pairs(Locations) do

	Autofarm:CreateButton({
		Name = name,
		Callback = function()
			CarTeleport(location)
		end,
	})

end

-----------------------------------------------
-- MISC SECTION
-----------------------------------------------
local Misc = Window:CreateTab("Misc", 4483362458)
local AutoRefuel = Misc:CreateToggle({
   Name = "AutoRefuel",
   CurrentValue = true,
   Flag = "AutoRefuel",
   Callback = function(Value)
        AutoRefuelFunction(Value)
    end
})

local DestroyBlack = Misc:CreateButton({
	Name = "Destroy Black Market(Recommended for Autofarm)",
	Callback = function()
		DestroyBlackMarket()
	end,
})

local BetterGates = Misc:CreateButton({
	Name = "Better Gates",
	Callback = function()
		BetterGatesFunction()
	end,
})

local InfiniteYieldButton = Misc:CreateButton({
	Name = "Load Infinite Yield",
	Callback = function()
		InfiniteYieldFunction()
	end,
})

local DestoryBorderLimitations = Misc:CreateButton({
	Name = "Remove Border Speed Limit and Border Parking Restrictors",
	Callback = function()
		RemoveBorderLimits()
	end,
})

local LowLagButton = Misc:CreateButton({
	Name = "Low Lag",
	Callback = function()
		LowLagFunction()
	end,
})
