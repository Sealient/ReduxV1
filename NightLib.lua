-- Load the library
local NightLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sealient/NightLib/refs/heads/main/NightLib.lua"))()

-- Initialize the UI
local NightlyUI = {}

-- Create Base UI Outline
function NightlyUI:CreateBaseUI()
    -- StarterGui Setup
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = ScreenGui
    mainFrame.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
    mainFrame.BackgroundTransparency = 0.100
    mainFrame.BorderColor3 = Color3.fromRGB(112, 10, 240)
    mainFrame.Position = UDim2.new(0.343820214, 0, 0.0577200577, 0)
    mainFrame.Size = UDim2.new(0, 417, 0, 612)
    
    -- Add UI Gradient
    local uiGradient = Instance.new("UIGradient")
    uiGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 255)), 
        ColorSequenceKeypoint.new(0.24, Color3.fromRGB(0, 0, 0)), 
        ColorSequenceKeypoint.new(0.79, Color3.fromRGB(0, 0, 0)), 
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 255))
    }
    uiGradient.Parent = mainFrame
    
    -- Title TextLabel    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = mainFrame
    textLabel.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
    textLabel.BackgroundTransparency = 0.100
    textLabel.BorderColor3 = Color3.fromRGB(112, 10, 240)
    textLabel.Size = UDim2.new(0, 417, 0, 18)
    textLabel.Font = Enum.Font.SourceSans
    textLabel.Text = "N     I     G     H     T     L     Y"
    textLabel.TextColor3 = Color3.fromRGB(255, 0, 255)
    textLabel.TextScaled = true
    textLabel.TextWrapped = true
    
    local uiGradient2 = Instance.new("UIGradient")
    uiGradient2.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 255)), 
        ColorSequenceKeypoint.new(0.24, Color3.fromRGB(0, 0, 0)), 
        ColorSequenceKeypoint.new(0.51, Color3.fromRGB(255, 0, 255)), 
        ColorSequenceKeypoint.new(0.79, Color3.fromRGB(0, 0, 0)), 
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 255))
    }
    uiGradient2.Parent = textLabel

    -- Tabs Frame
    local tabsFrame = Instance.new("Frame")
    tabsFrame.Name = "TabsFrame"
    tabsFrame.Parent = mainFrame
    tabsFrame.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
    tabsFrame.BackgroundTransparency = 0.100
    tabsFrame.BorderColor3 = Color3.fromRGB(112, 10, 240)
    tabsFrame.Position = UDim2.new(0, 0, 0.0294117648, 0)
    tabsFrame.Size = UDim2.new(0, 417, 0, 29)
    
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Parent = tabsFrame
    uiListLayout.FillDirection = Enum.FillDirection.Horizontal
    uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local uiGradient3 = Instance.new("UIGradient")
    uiGradient3.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 255)), 
        ColorSequenceKeypoint.new(0.24, Color3.fromRGB(0, 0, 0)), 
        ColorSequenceKeypoint.new(0.79, Color3.fromRGB(0, 0, 0)), 
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 255))
    }
    uiGradient3.Parent = tabsFrame
    
    -- Content Background Frame
    local contentBackgroundFrame = Instance.new("Frame")
    contentBackgroundFrame.Name = "ContentBackgroundFrame"
    contentBackgroundFrame.Parent = mainFrame
    contentBackgroundFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    contentBackgroundFrame.BackgroundTransparency = 0.100
    contentBackgroundFrame.BorderColor3 = Color3.fromRGB(112, 10, 240)
    contentBackgroundFrame.Position = UDim2.new(0.023980815, 0, 0.0980392173, 0)
    contentBackgroundFrame.Size = UDim2.new(0, 398, 0, 541)
    
    local uiGradient4 = Instance.new("UIGradient")
    uiGradient4.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 255)), 
        ColorSequenceKeypoint.new(0.24, Color3.fromRGB(0, 0, 0)), 
        ColorSequenceKeypoint.new(0.79, Color3.fromRGB(0, 0, 0)), 
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 255))
    }
    uiGradient4.Parent = contentBackgroundFrame
    
    return {
        ScreenGui = ScreenGui,
        MainFrame = mainFrame,
        TabsFrame = tabsFrame,
        ContentBackgroundFrame = contentBackgroundFrame,
    }
end

-- Initialize the Base UI
local uiElements = NightlyUI:CreateBaseUI()

-- Export `NightlyUI` for dynamic tabs, sections, toggles 
return NightlyUI
