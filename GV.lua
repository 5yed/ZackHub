------------------------------------
-- LIBRARY SETUP & WHITELIST CHECK
------------------------------------

local Library = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local url = "https://raw.githubusercontent.com/5yed/ZackHub/refs/heads/main/Whitelist"
local content = game:HttpGet(url)

local player = game.Players.LocalPlayer
local isWhitelisted = false

for line in content:gmatch("[^\r\n]+") do
    local userId, enabled = line:match("^(%d+), (%a+)$")

    if tonumber(userId) == player.UserId then
        isWhitelisted = enabled:lower() == "true"
        break
    end
end

if isWhitelisted then
	Library:Notify({
        Title = "ZackHub",
        Content = "Whitelisted",
        Duration = 6.5,
        Image = 4483362458,
    })
else
    player:Kick("You are not whitelisted to use this script.")
end

------------------------------------
-- WINDOW SETUP
------------------------------------

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
      Enabled = false,
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

------------------------
-- COMPLETE CHECKLIST
------------------------

local function completeChecklist()
	local Players = game:GetService("Players")
	local VirtualInputManager = game:GetService("VirtualInputManager")

	local player = Players.LocalPlayer
	local gui = player.PlayerGui

	local conveyor = workspace.Buildings.AWAWAWAWA.SaharaInterior.Interior["Conveyor belt"]

	local prompt
	for _, obj in ipairs(conveyor:GetDescendants()) do
		if obj:IsA("ProximityPrompt") then
			prompt = obj
			break
		end
	end

	if not prompt then
		warn("Couldn't find conveyor prompt.")
		return false
	end

    prompt.RequiresLineOfSight = false
	prompt.MaxActivationDistance = math.huge
	task.wait(0.25)

	local camera = workspace.CurrentCamera
	local promptPart = prompt.Parent

	camera.CFrame = CFrame.lookAt(
		camera.CFrame.Position,
		promptPart.Position
	)

	prompt:InputHoldBegin()
	task.wait(prompt.HoldDuration)
	prompt:InputHoldEnd()

	local checklist = gui.UI.Uni.Interfaces.AmazonChecklist
	repeat
		task.wait(0.2)
	until checklist.Visible

	local buttons = gui.UI.Uni.Interfaces.BoxDelivery:WaitForChild("Buttons")

	local function clickButton(button)
		local pos = button.AbsolutePosition
		local size = button.AbsoluteSize

		local x = pos.X + size.X/2
		local y = pos.Y + size.Y/2

		VirtualInputManager:SendMouseMoveEvent(x, y, game)
		task.wait(0.05)
		VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
		task.wait(0.05)
		VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
	end

	for _, item in ipairs(checklist.List:GetChildren()) do
		local value = item:FindFirstChild("Value")
		local amount = value and tonumber(value.Text)

		if amount and amount > 0 then
			local button = buttons:FindFirstChild(item.Name)

			if button and button:IsA("ImageButton") then
				for i = 1, amount do
					clickButton(button)
					task.wait(0.1)
				end
			else
				warn("Couldn't find button:", item.Name)
			end
		end
	end

	return true
end

------------------------
-- COLLECT BOX PADS
------------------------

local function collectBoxPads()
	local boxPads = {}

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj.Name == "BoxPad" then
			table.insert(boxPads, obj)

			for _, descendant in ipairs(obj:GetDescendants()) do
				if descendant:IsA("ProximityPrompt") then
					descendant.MaxActivationDistance = math.huge
					descendant.RequiresLineOfSight = false
					descendant.HoldDuration = 0
				end
			end
		end
	end

	return boxPads
end

------------------------
-- SPAWN VEHICLE
------------------------

local function spawnVehicle()
	local Players = game:GetService("Players")
	local VirtualInputManager = game:GetService("VirtualInputManager")

	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local garage = playerGui.UI.Uni.Interfaces.Garage
	local jobCar = garage.JobCars.CarsList.JobCar4548

	if garage:IsA("ScreenGui") then
		garage.Enabled = true
	elseif garage:IsA("GuiObject") then
		garage.Visible = true
	end

	task.wait(1)

	local pos = jobCar.AbsolutePosition
	local size = jobCar.AbsoluteSize

	local x = pos.X + size.X / 2
	local y = pos.Y + size.Y / 2

	VirtualInputManager:SendMouseMoveEvent(x, y, game)
	task.wait(0.2)

	VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
	task.wait(0.1)
	VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)

	task.wait(1)

	if garage:IsA("ScreenGui") then
		garage.Enabled = false
	elseif garage:IsA("GuiObject") then
		garage.Visible = false
	end

	return true
end

------------------------
-- ACTIVATE PAD
------------------------

local function activatePad(pad)
	local Players = game:GetService("Players")
	local UserInputService = game:GetService("UserInputService")

	local player = Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")

	local prompt
	for _, obj in ipairs(pad:GetDescendants()) do
		if obj:IsA("ProximityPrompt") then
			prompt = obj
			break
		end
	end

	if not prompt then
		return false
	end

	local part = prompt.Parent

	if not part:IsA("BasePart") then
		part = prompt:FindFirstAncestorWhichIsA("BasePart")
	end

	if not part then
		return false
	end

	local originalCFrame = part.CFrame

	part.CFrame = hrp.CFrame * CFrame.new(0, 0, -5)

	prompt.RequiresLineOfSight = false
	prompt.MaxActivationDistance = math.huge
	prompt.HoldDuration = 0

	task.wait(0.2)

	local camera = workspace.CurrentCamera
	local promptPart = prompt.Parent

	camera.CFrame = CFrame.lookAt(
		camera.CFrame.Position,
		promptPart.Position
	)

	task.wait(0.5)

	fireproximityprompt(prompt)

	part.CFrame = originalCFrame

	return true
end

------------------------
-- HANDLE BOX DELIVERY
------------------------

local function handleBoxDelivery()

	local Players = game:GetService("Players")
	local VirtualInputManager = game:GetService("VirtualInputManager")

	local player = Players.LocalPlayer

	local function clickButton(button)
		local pos = button.AbsolutePosition
		local size = button.AbsoluteSize
		local x = pos.X + size.X / 2
		local y = pos.Y + size.Y / 2

		VirtualInputManager:SendMouseMoveEvent(
			x,
			y,
			game
		)

		task.wait(0.3)
		VirtualInputManager:SendMouseButtonEvent(
			x,
			y,
			0,
			true,
			game,
			1
		)
		task.wait(0.1)
		VirtualInputManager:SendMouseButtonEvent(
			x,
			y,
			0,
			false,
			game,
			1
		)
	end

	local gui = player.PlayerGui.UI.Uni.Interfaces.BoxDelivery
	repeat
		task.wait(0.2)
	until gui.Visible

	local boxNeeded = gui.BoxNeeded
	local buttons = gui.Buttons
	local neededImage = boxNeeded.Image

	for _, button in ipairs(buttons:GetDescendants()) do
		if button:IsA("ImageButton") then
			local buttonImage = button:GetAttribute("Image")

			if buttonImage == neededImage or button.Image == neededImage then
				clickButton(button)
				return true
			end
		end
	end
	return false
end

------------------------
-- TRIGGER CAR PROMPT
------------------------

local function triggerCarPrompt()
	local Players = game:GetService("Players")

	local player = Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")

	local carName = player.Name .. "-Car"

	local car = workspace:WaitForChild("SessionVehicles"):WaitForChild(carName, 10)

	if not car then
		return false
	end

	local prompt

	repeat
		prompt = car:FindFirstChildWhichIsA("ProximityPrompt", true)
		if not prompt then
			task.wait(0.2)
		end
	until prompt

	prompt.MaxActivationDistance = 9999

	local promptPart = prompt.Parent

	if not promptPart:IsA("BasePart") then
		promptPart = prompt:FindFirstAncestorWhichIsA("BasePart")
	end

	if not promptPart then
		return false
	end

	hrp.CFrame = promptPart.CFrame * CFrame.new(0, 3, 5)

	task.wait(0.5)

	local camera = workspace.CurrentCamera

	camera.CFrame = CFrame.lookAt(
		camera.CFrame.Position,
		promptPart.Position
	)

	task.wait(0.5)
	fireproximityprompt(prompt)
	return true
end

------------------------
-- GET PLACEMENT MODEL
------------------------

local function getPlacementModel(timeout)
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")

	local player = Players.LocalPlayer
	local mouse = player:GetMouse()

	local validMeshes = {
		Long = true,
		SmallLong = true,
		Medium = true,
		Small = true,
		Large = true,
	}

	local start = tick()

	while tick() - start < (timeout or 5) do
		local target = mouse.Target

		if target
			and target:IsA("MeshPart")
			and validMeshes[target.Name] then

			local model = target:FindFirstAncestorOfClass("Model")

			if model and model.Parent == workspace then
				return model
			end
		end

		RunService.RenderStepped:Wait()
	end
	return nil
end

------------------------
-- PLACE MODELS
------------------------

local function placeModelsOnPad(model, pad)
	local modelCFrame = model:GetPivot()
	local padCFrame = pad.CFrame

	model:PivotTo(padCFrame)
end

------------------------
-- TELEPORT PLAYER
------------------------

function teleport(stage, turn)
	local player = game.Players.LocalPlayer

	if stage == 1 then
		player.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(1301.79, -77.85, -9968.01) * CFrame.Angles(0,math.rad(turn),0)
	elseif stage == 2 then
		player.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(1256.83, -77.85, -9981.08) * CFrame.Angles(0,math.rad(turn),0)
	end
end

------------------------------------------------
-- MAIN LOOP
------------------------------------------------

local farming = false

function runToggle(Value)
	farming = Value
	if not farming then return end

	task.spawn(function()
		teleport(1, -90)
		completeChecklist()

		if not farming then return end
		teleport(2, -90)
		task.wait(0.5)

		if not farming then return end
		spawnVehicle()
		task.wait(0.5)

		while farming do
			local boxPads = collectBoxPads()

			for _, pad in ipairs(boxPads) do
				if not farming then break end
				activatePad(pad)
				task.wait(0.5)

				if not farming then break end
				triggerCarPrompt()
				task.wait(0.5)

				if not farming then break end
				handleBoxDelivery()
				task.wait(0.5)

				if not farming then break end
				teleport(2, 90)
				task.wait(2)

				local package = getPlacementModel()

				if package and farming then
					placeModelsOnPad(package, pad)
					task.wait(1)
				end
			end
			task.wait(1)
		end
		if farming then
			warn("FINISHED")
		end
	end)
end

-----------------------------------------------
-- MAIN UI SETUP
-----------------------------------------------
Library:Notify({
   Title = "ZachHub",
   Content = "Use 'P' to hide/unhide the UI.",
   Duration = 5,
   Image = 4483362458,
})

-----------------------------------------------
-- AUTOFARM UI SECTION
-----------------------------------------------

local Autofarm = Window:CreateTab("Autofarm", 4483362458)
local GrinderSection = Autofarm:CreateSection("Sahara Delivery Farm")

Autofarm:CreateToggle({
	Name = "Sahara Delivery Farm",
	CurrentValue = false,
	Flag = "Sahara",
	Callback = function(Value)
		runToggle(Value)
	end
})

local Paragraph = Autofarm:CreateParagraph({Title = "NOTE", Content = "Make sure you change your team to Sahara Delivery Driver before toggling the script."})
