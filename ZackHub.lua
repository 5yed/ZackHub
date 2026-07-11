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

			--------------------------------------------------
			-- Trigger
			--------------------------------------------------
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


			--------------------------------------------------
			-- Prompts
			--------------------------------------------------
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


			--------------------------------------------------
			-- Highlight ONLY Gates With Prompts
			--------------------------------------------------
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


	--------------------------------------------------
	-- Notifications
	--------------------------------------------------

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
-- CAR TELEPORT SYSTEM
-----------------------------------------------

local STEP_SIZE = 1500
local HEIGHT_ABOVE_GROUND = 8
local WAIT_BETWEEN_JUMPS = 2

local Locations = {
	["Smuggler 1"] = CFrame.new(-201.39, 17.01, 1244.04),
	["Smuggler 2"] = CFrame.new(208.26, 17.07, -46.06),
	["Jewelry"] = CFrame.new(-75.03, 18.45, 926.13),
	["Bank"] = CFrame.new(-286.19, 17.05, -252.29),
	["Safe Spot"] = CFrame.new(-200.45, 132.86, 230.38),

	["Buy Jewelry"] = CFrame.new(6821.61, 17.24, 22.11),
	["Launder"] = CFrame.new(6809.25, 17.27, -34.69),
	["Buy Crowbar"] = CFrame.new(6806.12, 17.24, -7.75),
}


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


			task.wait(WAIT_BETWEEN_JUMPS)

		end

	end)
end

-----------------------------------------------
-- AUTO GRINDER SYSTEM
-----------------------------------------------

local AutoGrinderRunning = false
local AutoGrinderThread = nil
local TeleportCancelled = false


local GrinderRoute = {
	Locations["Buy Jewelry"],
	Locations["Smuggler 1"],
	Locations["Launder"]
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
	
	if not Value then
		StopAutoGrinder()
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

			for _, location in ipairs(GrinderRoute) do

				if not AutoGrinderRunning then
					break
				end


				CarTeleport(location)


				-- Allow teleport to complete
				local vehicle = getOwnedVehicle()

				if vehicle then

					repeat
						task.wait(0.25)

						local distance =
							(vehicle:GetPivot().Position - location.Position).Magnitude

					until distance < 20 or not AutoGrinderRunning

				end

			end

		end


		AutoGrinderThread = nil

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

	-- Remove textures and decals
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Texture") or obj:IsA("Decal") then
			obj:Destroy()
		end
	end

	-- Remove laggy objects
	for _, name in ipairs({
		"Gates",
		"Map",
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

	-- Remove all world buyable items except Crowbar and Fake Diamond Ring
	local worldBuyableItems = workspace:FindFirstChild("WorldBuyableItems")
	
	if worldBuyableItems then
		for _, item in ipairs(worldBuyableItems:GetChildren()) do
			if item.Name ~= "Crowbar" and item.Name ~= "Fake Diamond Ring" then
				item:Destroy()
			end
		end
	end

	-- Remove wheels from current vehicle
	local vehicles = workspace:WaitForChild("Vehicles")
	for _, vehicle in ipairs(vehicles:GetChildren()) do
		removeVehicleWheels(vehicle)
	end

	-- Remove wheels from future spawned vehicles
	if not VehicleWatcherConnection then
		VehicleWatcherConnection = vehicles.ChildAdded:Connect(function(vehicle)
			task.wait(0.25) -- Give the vehicle time to finish loading
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
-- AUTO GRINDER
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

-----------------------------------------------
-- TELEPORT SETTINGS
-----------------------------------------------
local SettingsSection = Autofarm:CreateSection("Teleport Settings")

Autofarm:CreateSlider({
	Name = "Step Size",
	Range = {100,2000},
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

-----------------------------------------------
-- CAR TELEPORT BUTTONS
-----------------------------------------------

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
