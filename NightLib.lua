-- NightlyUI Library
local NightlyUI = {}

-- Base UI Creation
function NightlyUI:CreateBaseUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.BorderColor3 = Color3.fromRGB(112, 10, 240)
    MainFrame.Position = UDim2.new(0.3438, 0, 0.0577, 0)
    MainFrame.Size = UDim2.new(0, 417, 0, 612)
    
    -- Add UI Gradient to MainFrame
    local MainFrameGradient = Instance.new("UIGradient")
    MainFrameGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(0.24, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.79, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
    }
    MainFrameGradient.Parent = MainFrame

    -- Title TextLabel
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Parent = MainFrame
    TextLabel.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
    TextLabel.BackgroundTransparency = 0.1
    TextLabel.BorderColor3 = Color3.fromRGB(112, 10, 240)
    TextLabel.Size = UDim2.new(0, 417, 0, 18)
    TextLabel.Font = Enum.Font.SourceSans
    TextLabel.Text = "N     I     G     H     T     L     Y"
    TextLabel.TextColor3 = Color3.fromRGB(255, 0, 255)
    TextLabel.TextScaled = true
    TextLabel.TextSize = 14
    TextLabel.TextWrapped = true

    -- Add UI Gradient to TextLabel
    local TextLabelGradient = Instance.new("UIGradient")
    TextLabelGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(0.24, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.51, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(0.79, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
    }
    TextLabelGradient.Parent = TextLabel

    -- Tabs Frame
    local TabsFrame = Instance.new("Frame")
    TabsFrame.Name = "TabsFrame"
    TabsFrame.Parent = MainFrame
    TabsFrame.BackgroundColor3 = Color3.fromRGB(39, 39, 39)
    TabsFrame.BackgroundTransparency = 0.1
    TabsFrame.BorderColor3 = Color3.fromRGB(112, 10, 240)
    TabsFrame.Position = UDim2.new(0, 0, 0.0294, 0)
    TabsFrame.Size = UDim2.new(0, 417, 0, 29)

    -- Add UI Gradient to TabsFrame
    local TabsFrameGradient = Instance.new("UIGradient")
    TabsFrameGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(0.24, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.79, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
    }
    TabsFrameGradient.Parent = TabsFrame

    -- Add UIListLayout to TabsFrame
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = TabsFrame
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Content Background Frame
    local ContentBackgroundFrame = Instance.new("Frame")
    ContentBackgroundFrame.Name = "ContentBackgroundFrame"
    ContentBackgroundFrame.Parent = MainFrame
    ContentBackgroundFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ContentBackgroundFrame.BackgroundTransparency = 0.1
    ContentBackgroundFrame.BorderColor3 = Color3.fromRGB(112, 10, 240)
    ContentBackgroundFrame.Position = UDim2.new(0.024, 0, 0.098, 0)
    ContentBackgroundFrame.Size = UDim2.new(0, 398, 0, 541)

    -- Add UI Gradient to ContentBackgroundFrame
    local ContentBackgroundFrameGradient = Instance.new("UIGradient")
    ContentBackgroundFrameGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(0.24, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.79, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
    }
    ContentBackgroundFrameGradient.Parent = ContentBackgroundFrame

        -- Add UIListLayout to TabsFrame
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = ContentBackgroundFrame
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Save references for later use
    self.ScreenGui = ScreenGui
    self.MainFrame = MainFrame
    self.TabsFrame = TabsFrame
    self.ContentFrame = ContentBackgroundFrame
end

-- Tab Creation
function NightlyUI:CreateTab(tabName, content)
    local button = Instance.new("TextButton")
    button.Name = tabName .. "Button"
    button.Parent = self.TabsFrame -- Correctly parented to the TabsFrame
    button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundTransparency = 1
    button.Size = UDim2.new(0, 48, 0, 29)
    button.Font = Enum.Font.SourceSans
    button.TextColor3 = Color3.fromRGB(255, 0, 255)
    button.TextSize = 14
    button.Text = tabName

    -- Content for the tab
    local tabContentFrame = Instance.new("Frame")
    tabContentFrame.Name = tabName .. "Content"
    tabContentFrame.Parent = self.ContentFrame
    tabContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tabContentFrame.Size = UDim2.new(1, 0, 1, 0)
    tabContentFrame.Visible = false
    tabContentFrame.BackgroundTransparency = 0.1
    tabContentFrame.BorderColor3 = Color3.fromRGB(112, 10, 240)
    
    -- Add the custom content (e.g., labels, buttons)
    local customContent = content(tabContentFrame)

    -- Add interactivity to tab button
    button.MouseButton1Click:Connect(function()
        -- Hide all other content
        for _, frame in pairs(self.ContentFrame:GetChildren()) do
            if frame:IsA("Frame") then
                frame.Visible = false
            end
        end
        -- Show the clicked tab's content
        tabContentFrame.Visible = true
    end)

    return button
end

-- Create Toggle Function
function NightlyUI:CreateToggle(toggleName, initialState, position)
    local toggle = Instance.new("TextButton")
    toggle.Name = toggleName
    toggle.Parent = self.ContentBackgroundFrame  -- Make sure it goes inside the content frame of the current tab
    toggle.BackgroundColor3 = Color3.fromRGB(48, 48, 48)
    toggle.Size = UDim2.new(0, 200, 0, 30)  -- Adjust size as needed
    toggle.Position = position  -- Position provided when creating toggle
    toggle.Font = Enum.Font.SourceSans
    toggle.TextColor3 = Color3.fromRGB(255, 0, 255)
    toggle.TextSize = 14
    toggle.Text = toggleName .. ": " .. (initialState and "Enabled" or "Disabled")
    
    -- Add functionality for toggling
    toggle.MouseButton1Click:Connect(function()
        initialState = not initialState
        toggle.Text = toggleName .. ": " .. (initialState and "Enabled" or "Disabled")
        print(toggleName .. " is now " .. (initialState and "Enabled" or "Disabled"))
    end)
    
    return toggle
end

-- Example usage
NightlyUI:CreateBaseUI()

-- Create Settings Tab with content
NightlyUI:CreateTab("Settings", function(parentFrame)
    -- Add custom elements for Settings tab here
    local label = Instance.new("TextLabel")
    label.Parent = parentFrame
    label.Text = "Settings Content"
    label.Size = UDim2.new(0, 200, 0, 30)
    label.Position = UDim2.new(0.5, -100, 0.5, -15)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
end)

-- Return Library
return NightlyUI
