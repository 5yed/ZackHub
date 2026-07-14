local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")

local currentPadObject = nil
local camera = workspace.CurrentCamera

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local boxPads = {}
local currentPad = 0
local started = false


-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BoxPadGUI"
screenGui.Parent = player.PlayerGui


local startButton = Instance.new("TextButton")
startButton.Size = UDim2.new(0, 150, 0, 50)
startButton.Position = UDim2.new(0, 20, 0, 100)
startButton.Text = "Start"
startButton.Parent = screenGui

local function clickButton(button)

	print("Clicking:", button:GetFullName())

	local pos = button.AbsolutePosition
	local size = button.AbsoluteSize

	local x = pos.X + size.X / 2
	local y = pos.Y + size.Y / 2

	print("Position:", x, y)


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

local function carspawner()
    local playerGui = player:WaitForChild("PlayerGui")

    local garage = playerGui.UI.Uni.Interfaces.Garage
    local carsList = garage.JobCars.CarsList

    local jobCar

    -- Find the first available job car button
    for _, obj in ipairs(carsList:GetChildren()) do
        if obj:IsA("GuiButton") or obj:IsA("ImageButton") or obj:IsA("TextButton") then
            jobCar = obj
            break
        end
    end

    if not jobCar then
        warn("No job car found.")
        return
    end

    if garage:IsA("ScreenGui") then
        garage.Enabled = true
    else
        garage.Visible = true
    end

    task.wait(1)

    clickButton(jobCar)

    task.wait(1)

    if garage:IsA("ScreenGui") then
        garage.Enabled = false
    else
        garage.Visible = false
    end
end

local function enableCarPrompt()
    local carFolder = workspace:WaitForChild("SessionVehicles")

    local carName = player.Name .. "-Car"

    local car = carFolder:WaitForChild(carName)

    local prompt = car:WaitForChild("ProximityPrompt", 10)

    if not prompt then
        prompt = car:FindFirstChildWhichIsA("ProximityPrompt", true)
    end

    if prompt then
        prompt.MaxActivationDistance = 20
    else
        warn("No ProximityPrompt found in car.")
    end
end

local function facePrompt(prompt)

	local part = prompt.Parent

	if not part:IsA("BasePart") then
		part = prompt:FindFirstAncestorWhichIsA("BasePart")
	end

	if not part then
		return
	end


	local direction = (part.Position - hrp.Position).Unit

	hrp.CFrame = CFrame.new(
		hrp.Position,
		hrp.Position + Vector3.new(direction.X, 0, direction.Z)
	)

end

local function handleBoxDelivery()

	local gui = player.PlayerGui.UI.Uni.Interfaces.BoxDelivery

	repeat
		task.wait(0.2)
	until gui.Visible


	print("BoxDelivery opened")


	local boxNeeded = gui.BoxNeeded
	local buttons = gui.Buttons

	local neededImage = boxNeeded.Image

	print("Needed:", neededImage)


	for _, button in ipairs(buttons:GetDescendants()) do

		if button:IsA("ImageButton") then

			print(
				"Checking:",
				button:GetFullName(),
				button.Image,
				button:GetAttribute("Image")
			)


			local buttonImage = button:GetAttribute("Image")


			if buttonImage == neededImage or button.Image == neededImage then

				print("MATCH FOUND:", button:GetFullName())


				clickButton(button)


				return

			end
		end
	end


	warn("No matching button found")

end

local function moveNearPrompt(prompt)

	local part = prompt.Parent

	if not part:IsA("BasePart") then
		part = prompt:FindFirstAncestorWhichIsA("BasePart")
	end

	if not part then
		return
	end

	hrp.CFrame = part.CFrame * CFrame.new(0, 3, 5)

	task.wait(0.5)

end

local function faceCameraToPrompt(prompt)

	local part = prompt.Parent

	if not part:IsA("BasePart") then
		part = prompt:FindFirstAncestorWhichIsA("BasePart")
	end

	if not part then
		return
	end

	local camera = workspace.CurrentCamera

	camera.CFrame = CFrame.new(
		camera.CFrame.Position,
		part.Position
	)

end

local function triggerCarPrompt()

	local carName = player.Name .. "-Car"

    local car = workspace.SessionVehicles:WaitForChild(carName, 10)

    if not car then
        warn("Couldn't find spawned car:", carName)
        return
    end

	local prompt

	repeat
		prompt = car:FindFirstChild("ProximityPrompt", true)
		task.wait(0.2)
	until prompt


	prompt.MaxActivationDistance = 9999


	local part = prompt.Parent

	if not part:IsA("BasePart") then
		part = prompt:FindFirstAncestorWhichIsA("BasePart")
	end


	if part then
		hrp.CFrame = part.CFrame * CFrame.new(0,3,5)
	end


	task.wait(0.5)

	faceCameraToPrompt(prompt)

	task.wait(1)

	fireproximityprompt(prompt)

end

local function hoverOverPad()

	local camera = workspace.CurrentCamera

	-- use player's body position instead of pad position
	local screenPos, visible = camera:WorldToViewportPoint(
		hrp.Position - Vector3.new(0, 2.5, 0) -- around feet/legs
	)

	print(
		"Player screen position:",
		screenPos.X,
		screenPos.Y,
		"Visible:",
		visible
	)

	if visible and screenPos.Z > 0 then

		VirtualInputManager:SendMouseMoveEvent(
			screenPos.X,
			screenPos.Y,
			game
		)

		print("Mouse moved to player's feet")

	else
		warn("Player not visible on screen")
	end
end



-- Find BoxPads
local function getBoxPads()

	local pads = {}

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj.Name == "BoxPad" then
			table.insert(pads, obj)
		end
	end

	return pads
end

local function triggerPadPrompt(pad)

	local prompt

	repeat
		for _, obj in ipairs(pad:GetDescendants()) do
			if obj:IsA("ProximityPrompt") then
				prompt = obj
				break
			end
		end

		task.wait(0.2)

	until prompt


	prompt.MaxActivationDistance = 10


	local part = prompt.Parent

	if part:IsA("BasePart") then
		hrp.CFrame = part.CFrame * CFrame.new(0,3,5)
	end


	task.wait(0.5)

	faceCameraToPrompt(prompt)

	task.wait(1)

	fireproximityprompt(prompt)

end

local function enablePadPrompts()

	for _, pad in ipairs(boxPads) do

		for _, obj in ipairs(pad:GetDescendants()) do

			if obj:IsA("ProximityPrompt") then

				obj.MaxActivationDistance = 20

				print("Enabled:", obj:GetFullName())

			end
		end
	end
end

-- Teleport above pad
local function teleportToPad(index)

	local pad = boxPads[index]

	if not pad then
		warn("No pad at index:", index)
		return false
	end

	local cf

	if pad:IsA("BasePart") then
		cf = pad.CFrame
	elseif pad:IsA("Model") then
		cf = pad:GetPivot()
	end

	if cf then

		hrp.CFrame =
			cf
			* CFrame.new(10, 8, 0)
			* CFrame.Angles(0, math.rad(-90), 0)

		print("Teleported above pad", index)

		return true
	end

	return false
end

-- Main process
local function startProcess()

	if started then
		return
	end


	started = true


	hrp.CFrame =
		CFrame.new(1304.97,-77.76,-9965.97)
		*
		CFrame.Angles(0,math.rad(-90),0)



	local controlPanel =
		workspace.Buildings.AWAWAWAWA.SaharaInterior.Interior["Conveyor belt"]["Control panel"]


	local prompt


	repeat

		for _,obj in ipairs(controlPanel:GetDescendants()) do

			if obj:IsA("ProximityPrompt") then

				prompt = obj

				break

			end
		end

		task.wait(.5)

	until prompt



	prompt.MaxActivationDistance = 20

	fireproximityprompt(prompt)


	task.wait(1)



	local gui = player.PlayerGui

	local checklist =
		gui.UI.Uni.Interfaces.AmazonChecklist


	local buttons =
		gui.UI.Uni.Interfaces.BoxDelivery.Buttons

	local function pressButton(name,amount)

		local button = buttons:FindFirstChild(name)


		if button then

			for i=1,amount do

				clickButton(button)

				task.wait(.01)

			end

		else

			warn("Missing button:",name)

		end
	end

	for _,item in ipairs(checklist.List:GetChildren()) do

		local value = item:FindFirstChild("Value")


		if value then

			local amount = tonumber(value.Text)


			if amount and amount > 0 then

				pressButton(item.Name,amount)

			end
		end
	end



	print("Checklist completed")



	repeat

		task.wait(1)

		boxPads = getBoxPads()

		print("Searching pads:",#boxPads)

	until #boxPads > 0



	print("Pads found:",#boxPads)



	enablePadPrompts()

    for i = 1, #boxPads do

        currentPad = i
        currentPadObject = boxPads[i]

        teleportToPad(i)

        task.wait(1)

        carspawner()

        task.wait(2)

        triggerPadPrompt(currentPadObject)

        task.wait(1)

        triggerCarPrompt()

        task.wait(1)

        handleBoxDelivery()

        task.wait(1)

        -- return to the exact same pad
        local pad = currentPadObject

        local cf
        if pad:IsA("BasePart") then
            cf = pad.CFrame
        elseif pad:IsA("Model") then
            cf = pad:GetPivot()
        end

        if cf then
            hrp.CFrame =
                cf
                * CFrame.new(0, 8, 0)
                * CFrame.Angles(0, math.rad(-90), 0)
        end

        task.wait(1)

        camera.CameraType = Enum.CameraType.Custom

        task.wait(1)

        hoverOverPad()

    end

end



startButton.MouseButton1Click:Connect(function()

	startProcess()

end)
