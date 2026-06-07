local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Event = ReplicatedStorage.HDAdminClient.Signals.RequestCommand
local Player = Players.LocalPlayer

-- STATE
local Visible = true
local Dragging = false

-- Commands
local Commands = {
	{Text = "BKit", Command = "/bkit"},
	{Text = "CommandExecutor", Command = "/insert CommandExecutor"},
	{Text = "ChatEvent", Command = "/insert chatevent"},
	{Text = "JoinEvent", Command = "/insert joinevent"},
	{Text = "Re", Command = "/re"},
	{Text = "R6", Command = "/r6"},
	{Text = "Char Me", Command = "/char me xzylixy"},
	{Text = "Explode All", Command = "/explode all"},
	{Text = "Kill All", Command = "/kill all"},
}

-- Remove old GUI
pcall(function()
	local old = Player.PlayerGui:FindFirstChild("HDAdminQuickCommands")
	if old then old:Destroy() end
end)

-- GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "HDAdminQuickCommands"
Gui.ResetOnSpawn = false
Gui.Parent = Player.PlayerGui

-- Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.fromOffset(150, 40)
Frame.Position = UDim2.new(0.5, -75, 0.5, -20)
Frame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
Frame.BackgroundTransparency = 0.1
Frame.BorderSizePixel = 0
Frame.Parent = Gui

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 24)
Title.BackgroundTransparency = 1
Title.Text = "MAS Menu"
Title.Font = Enum.Font.GothamSemibold
Title.TextSize = 13
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Parent = Frame

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.fromOffset(20, 20)
CloseButton.Position = UDim2.new(1, -24, 0, 2)
CloseButton.BackgroundTransparency = 1
CloseButton.Text = "✕"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseButton.Parent = Frame

CloseButton.MouseEnter:Connect(function()
	CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
end)

CloseButton.MouseLeave:Connect(function()
	CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
end)

CloseButton.MouseButton1Click:Connect(function()
	Gui:Destroy()
end)

-- Container
local Container = Instance.new("Frame")
Container.Position = UDim2.fromOffset(8, 28)
Container.Size = UDim2.new(1, -16, 1, -36)
Container.BackgroundTransparency = 1
Container.Parent = Frame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 4)
Layout.Parent = Container

-- AUTO RESIZE
local function ResizeFrame()
	Frame.Size = UDim2.fromOffset(
		150,
		36 + Layout.AbsoluteContentSize.Y + 8
	)
end

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(ResizeFrame)
task.defer(ResizeFrame)

-- Buttons
for _, v in ipairs(Commands) do
	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(1, 0, 0, 24)
	Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	Button.BorderSizePixel = 0
	Button.Text = v.Text
	Button.Font = Enum.Font.Gotham
	Button.TextSize = 12
	Button.TextColor3 = Color3.new(1, 1, 1)
	Button.Parent = Container

	Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)

	Button.MouseEnter:Connect(function()
		Button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	end)

	Button.MouseLeave:Connect(function()
		Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	end)

	Button.MouseButton1Click:Connect(function()
		Event:InvokeServer(v.Command)
	end)
end

-- FADE SYSTEM
local function SetVisible(state)
	Visible = state
	Gui.Enabled = true

	local goal = {
		BackgroundTransparency = state and 0.1 or 1
	}

	TweenService:Create(Frame, TweenInfo.new(0.15), goal):Play()

	task.delay(0.15, function()
		if not state then
			Gui.Enabled = false
		end
	end)
end

-- G TOGGLE
UIS.InputBegan:Connect(function(input, processed)
	if processed then return end

	if input.KeyCode == Enum.KeyCode.G then
		SetVisible(not Visible)
	end
end)

-- DRAGGING
local DragStart
local StartPos

Title.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 then
		Dragging = true
		DragStart = Input.Position
		StartPos = Frame.Position

		Input.Changed:Connect(function()
			if Input.UserInputState == Enum.UserInputState.End then
				Dragging = false
			end
		end)
	end
end)

UIS.InputChanged:Connect(function(Input)
	if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
		local Delta = Input.Position - DragStart

		Frame.Position = UDim2.new(
			StartPos.X.Scale,
			StartPos.X.Offset + Delta.X,
			StartPos.Y.Scale,
			StartPos.Y.Offset + Delta.Y
		)
	end
end)