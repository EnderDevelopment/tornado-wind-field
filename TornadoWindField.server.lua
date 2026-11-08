local RunService = game:GetService("RunService")

local WIND_FIELD_NAME = "wind field"
local TORNADO_NAME = "TORNADO"
local MIN_DURATION = 5
local MAX_DURATION = 20
local START_RADIUS = 6
local RISE_SPEED = 5
local ANGULAR_SPEED = math.rad(240)
local FLING_SPEED = 32
local FLING_UPWARD_SPEED = 12

local windField = workspace:FindFirstChild(WIND_FIELD_NAME, true)
local tornado = workspace:FindFirstChild(TORNADO_NAME, true)

if not windField or not windField:IsA("BasePart") then
	warn(("TornadoWindField: Workspace must contain a BasePart named %q."):format(WIND_FIELD_NAME))
	return
end

if not tornado then
	warn(("TornadoWindField: Workspace must contain an object named %q."):format(TORNADO_NAME))
	return
end

local activeParts = {}

local function getTornadoPosition()
	if tornado:IsA("BasePart") then
		return tornado.Position
	end

	if tornado:IsA("Model") then
		return tornado:GetPivot().Position
	end

	local tornadoPart = tornado:FindFirstChildWhichIsA("BasePart", true)
	return tornadoPart and tornadoPart.Position or nil
end

local function getPartsToMove(touchedPart)
	local assemblyRoot = touchedPart.AssemblyRootPart or touchedPart
	local parts = {}

	for _, descendant in ipairs(assemblyRoot:GetConnectedParts(true)) do
		if descendant:IsA("BasePart") then
			table.insert(parts, descendant)
		end
	end

	if #parts == 0 then
		table.insert(parts, touchedPart)
	end

	return parts, assemblyRoot
end

local function flingParts(parts, tornadoPosition)
	for _, part in ipairs(parts) do
		if part.Parent and not part.Anchored then
			local direction = part.Position - tornadoPosition
			if direction.Magnitude < 0.01 then
				direction = Vector3.new(1, 0, 0)
			end

			part.AssemblyLinearVelocity = direction.Unit * FLING_SPEED + Vector3.new(0, FLING_UPWARD_SPEED, 0)
		end
	end
end

local function liftAndRotate(touchedPart)
	local parts, assemblyRoot = getPartsToMove(touchedPart)
	if activeParts[assemblyRoot] then
		return
	end

	activeParts[assemblyRoot] = true

	for _, part in ipairs(parts) do
		part.Anchored = false
	end

	local duration = math.random(MIN_DURATION, MAX_DURATION)
	local elapsed = 0
	local startPosition = assemblyRoot.Position
	local tornadoPosition = getTornadoPosition()
	if not tornadoPosition then
		activeParts[assemblyRoot] = nil
		return
	end

	local offset = startPosition - tornadoPosition
	local startAngle = math.atan2(offset.Z, offset.X)
	local startRadius = math.max(Vector3.new(offset.X, 0, offset.Z).Magnitude, START_RADIUS)
	local startHeight = startPosition.Y - tornadoPosition.Y

	while elapsed < duration and assemblyRoot.Parent do
		local deltaTime = RunService.Heartbeat:Wait()
		elapsed += deltaTime

		local currentTornadoPosition = getTornadoPosition()
		if not currentTornadoPosition then
			break
		end

		local progress = math.clamp(elapsed / duration, 0, 1)
		local radius = startRadius + progress * 4
		local angle = startAngle + elapsed * ANGULAR_SPEED
		local height = startHeight + elapsed * RISE_SPEED
		local targetPosition = currentTornadoPosition + Vector3.new(
			math.cos(angle) * radius,
			height,
			math.sin(angle) * radius
		)
		local currentPosition = assemblyRoot.Position
		local movement = targetPosition - currentPosition

		assemblyRoot.AssemblyLinearVelocity = movement / math.max(deltaTime, 1 / 240)
		assemblyRoot.AssemblyAngularVelocity = Vector3.new(0, ANGULAR_SPEED, ANGULAR_SPEED * 0.35)
	end

	local finalTornadoPosition = getTornadoPosition()
	if finalTornadoPosition and assemblyRoot.Parent then
		flingParts(parts, finalTornadoPosition)
	end

	activeParts[assemblyRoot] = nil
end

windField.Touched:Connect(function(hit)
	if not hit:IsA("BasePart") or hit == windField then
		return
	end

	task.spawn(liftAndRotate, hit)
end)
