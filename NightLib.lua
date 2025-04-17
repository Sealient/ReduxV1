local MyUILib = {}
MyUILib.__index = MyUILib

-- Main configuration
MyUILib.Config = {
    Name = "MyUILib",
    Theme = {
        Background = Color3.fromRGB(30, 30, 30),
        Accent = Color3.fromRGB(0, 120, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Secondary = Color3.fromRGB(50, 50, 50)
    },
    TweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}

-- Instance containers
MyUILib.Windows = {}
MyUILib.Elements = {}

function MyUILib:CreateWindow(title)
    local window = {}
    window.__index = window
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = self.Config.Name
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    
    -- Protection (for exploits)
    local success, result = pcall(function()
        ScreenGui.Parent = game:GetService("CoreGui")
    end)
    
    if not success then
        ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Create main frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.BackgroundColor3 = self.Config.Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    -- Make draggable
    self:MakeDraggable(MainFrame)
    
    -- Add title bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = self.Config.Theme.Secondary
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "Title"
    TitleText.Size = UDim2.new(1, -60, 1, 0)
    TitleText.Position = UDim2.new(0, 10, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = title
    TitleText.Font = Enum.Font.GothamSemibold
    TitleText.TextSize = 14
    TitleText.TextColor3 = self.Config.Theme.Text
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar
    
    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.BackgroundTransparency = 1
    CloseButton.Text = "X"
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 14
    CloseButton.TextColor3 = self.Config.Theme.Text
    CloseButton.Parent = TitleBar
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Content area
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, 0, 1, -30)
    ContentArea.Position = UDim2.new(0, 0, 0, 30)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame
    
    -- UI Elements container
    local ElementsContainer = Instance.new("ScrollingFrame")
    ElementsContainer.Name = "ElementsContainer"
    ElementsContainer.Size = UDim2.new(1, -20, 1, -20)
    ElementsContainer.Position = UDim2.new(0, 10, 0, 10)
    ElementsContainer.BackgroundTransparency = 1
    ElementsContainer.ScrollBarThickness = 2
    ElementsContainer.ScrollBarImageColor3 = self.Config.Theme.Accent
    ElementsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    ElementsContainer.Parent = ContentArea
    
    -- UI List Layout for auto-organization
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = ElementsContainer
    
    -- Initialize window object
    window.ScreenGui = ScreenGui
    window.MainFrame = MainFrame
    window.ElementsContainer = ElementsContainer
    window.UIListLayout = UIListLayout
    
    -- Method to add tabbed sections if needed
    window.Tabs = {}
    
    -- Add methods
    setmetatable(window, self)
    self.Windows[title] = window
    
    return window
end

-- Make UI draggable
function MyUILib:MakeDraggable(frame)
    local dragging = false
    local dragInput, mousePos, framePos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
        end
    end)

    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            dragInput = input
        end
    end)

    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging and dragInput and mousePos then
            local delta = dragInput.Position - mousePos
            frame.Position = UDim2.new(
                framePos.X.Scale, 
                framePos.X.Offset + delta.X, 
                framePos.Y.Scale, 
                framePos.Y.Offset + delta.Y
            )
        end
    end)
end
self.Config.Theme.Secondary.G * 255 + 20, 
                self.Config.Theme.Secondary.B * 255 + 20
            )}
        ):Play()
    end)
    
    DropdownInteract.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            DropdownFrame, 
            self.Config.TweenInfo, 
            {BackgroundColor3 = self.Config.Theme.Secondary}
        ):Play()
    end)
    
    -- Dropdown methods
    function dropdown:Set(value)
        if table.find(dropdown.Options, value) then
            dropdown.Value = value
            SelectedText.Text = value
            
            if callback then
                callback(value)
            end
        end
    end
    
    -- Update canvas size
    self:UpdateCanvasSize(window)
    
    return dropdown
end

-- Textbox component
function MyUILib:CreateTextbox(window, text, placeholder, callback)
    local textbox = {}
    textbox.Value = ""
    
    -- Create textbox frame
    local TextboxFrame = Instance.new("Frame")
    TextboxFrame.Name = "Textbox_" .. text
    TextboxFrame.Size = UDim2.new(1, 0, 0, 60)
    TextboxFrame.BackgroundColor3 = self.Config.Theme.Secondary
    TextboxFrame.BorderSizePixel = 0
    TextboxFrame.Parent = window.ElementsContainer
    
    -- Textbox label
    local TextboxLabel = Instance.new("TextLabel")
    TextboxLabel.Name = "TextboxLabel"
    TextboxLabel.Size = UDim2.new(1, -20, 0, 20)
    TextboxLabel.Position = UDim2.new(0, 10, 0, 5)
    TextboxLabel.BackgroundTransparency = 1
    TextboxLabel.Text = text
    TextboxLabel.Font = Enum.Font.Gotham
    TextboxLabel.TextSize = 14
    TextboxLabel.TextColor3 = self.Config.Theme.Text
    TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextboxLabel.Parent = TextboxFrame
    
    -- Textbox input background
    local TextboxBG = Instance.new("Frame")
    TextboxBG.Name = "TextboxBG"
    TextboxBG.Size = UDim2.new(1, -20, 0, 30)
    TextboxBG.Position = UDim2.new(0, 10, 0, 25)
    TextboxBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TextboxBG.BorderSizePixel = 0
    TextboxBG.Parent = TextboxFrame
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = TextboxBG
    
    -- Textbox input
    local TextboxInput = Instance.new("TextBox")
    TextboxInput.Name = "TextboxInput"
    TextboxInput.Size = UDim2.new(1, -10, 1, 0)
    TextboxInput.Position = UDim2.new(0, 5, 0, 0)
    TextboxInput.BackgroundTransparency = 1
    TextboxInput.Text = ""
    TextboxInput.PlaceholderText = placeholder or "Enter text..."
    TextboxInput.Font = Enum.Font.Gotham
    TextboxInput.TextSize = 14
    TextboxInput.TextColor3 = self.Config.Theme.Text
    TextboxInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    TextboxInput.TextXAlignment = Enum.TextXAlignment.Left
    TextboxInput.ClearTextOnFocus = false
    TextboxInput.Parent = TextboxBG
    
    -- Focus highlight
    TextboxInput.Focused:Connect(function()
        game:GetService("TweenService"):Create(
            TextboxBG,
            self.Config.TweenInfo,
            {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}
        ):Play()
    end)
    
    TextboxInput.FocusLost:Connect(function(enterPressed)
        game:GetService("TweenService"):Create(
            TextboxBG,
            self.Config.TweenInfo,
            {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}
        ):Play()
        
        textbox.Value = TextboxInput.Text
        
        if callback then
            callback(TextboxInput.Text, enterPressed)
        end
    end)
    
    -- Textbox methods
    function textbox:Set(value)
        textbox.Value = value
        TextboxInput.Text = value
        
        if callback then
            callback(value, false)
        end
    end
    
    -- Update canvas size
    self:UpdateCanvasSize(window)
    
    return textbox
end

-- Label component
function MyUILib:CreateLabel(window, text)
    local label = {}
    
    -- Create label frame
    local LabelFrame = Instance.new("Frame")
    LabelFrame.Name = "Label_" .. text
    LabelFrame.Size = UDim2.new(1, 0, 0, 25)
    LabelFrame.BackgroundTransparency = 1
    LabelFrame.Parent = window.ElementsContainer
    
    -- Label text
    local LabelText = Instance.new("TextLabel")
    LabelText.Name = "LabelText"
    LabelText.Size = UDim2.new(1, -20, 1, 0)
    LabelText.Position = UDim2.new(0, 10, 0, 0)
    LabelText.BackgroundTransparency = 1
    LabelText.Text = text
    LabelText.Font = Enum.Font.Gotham
    LabelText.TextSize = 14
    LabelText.TextColor3 = self.Config.Theme.Text
    LabelText.TextXAlignment = Enum.TextXAlignment.Left
    LabelText.Parent = LabelFrame
    
    -- Label methods
    function label:Set(newText)
        LabelText.Text = newText
    end
    
    -- Update canvas size
    self:UpdateCanvasSize(window)
    
    return label
end

-- Section component (for grouping elements)
function MyUILib:CreateSection(window, title)
    local section = {}
    
    -- Create section frame
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Name = "Section_" .. title
    SectionFrame.Size = UDim2.new(1, 0, 0, 30)
    SectionFrame.BackgroundTransparency = 1
    SectionFrame.Parent = window.ElementsContainer
    
    -- Section divider line (left)
    local DividerLeft = Instance.new("Frame")
    DividerLeft.Name = "DividerLeft"
    DividerLeft.Size = UDim2.new(0.3, 0, 0, 1)
    DividerLeft.Position = UDim2.new(0, 10, 0.5, 0)
    DividerLeft.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    DividerLeft.BorderSizePixel = 0
    DividerLeft.Parent = SectionFrame
    
    -- Section title
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Name = "SectionTitle"
    SectionTitle.Size = UDim2.new(0.4, 0, 1, 0)
    SectionTitle.Position = UDim2.new(0.3, 10, 0, 0)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = title
    SectionTitle.Font = Enum.Font.GothamSemibold
    SectionTitle.TextSize = 12
    SectionTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Center
    SectionTitle.Parent = SectionFrame
    
    -- Section divider line (right)
    local DividerRight = Instance.new("Frame")
    DividerRight.Name = "DividerRight"
    DividerRight.Size = UDim2.new(0.3, -10, 0, 1)
    DividerRight.Position = UDim2.new(0.7, 0, 0.5, 0)
    DividerRight.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    DividerRight.BorderSizePixel = 0
    DividerRight.Parent = SectionFrame
    
    -- Update canvas size
    self:UpdateCanvasSize(window)
    
    return section
end

-- ColorPicker component
function MyUILib:CreateColorPicker(window, text, default, callback)
    local colorPicker = {}
    colorPicker.Value = default or Color3.fromRGB(255, 255, 255)
    colorPicker.Open = false
    
    -- Create ColorPicker frame
    local ColorPickerFrame = Instance.new("Frame")
    ColorPickerFrame.Name = "ColorPicker_" .. text
    ColorPickerFrame.Size = UDim2.new(1, 0, 0, 35)
    ColorPickerFrame.BackgroundColor3 = self.Config.Theme.Secondary
    ColorPickerFrame.BorderSizePixel = 0
    ColorPickerFrame.ClipsDescendants = true
    ColorPickerFrame.Parent = window.ElementsContainer
    
    -- ColorPicker text
    local ColorPickerText = Instance.new("TextLabel")
    ColorPickerText.Name = "ColorPickerText"
    ColorPickerText.Size = UDim2.new(1, -60, 1, 0)
    ColorPickerText.Position = UDim2.new(0, 10, 0, 0)
    ColorPickerText.BackgroundTransparency = 1
    ColorPickerText.Text = text
    ColorPickerText.Font = Enum.Font.Gotham
    ColorPickerText.TextSize = 14
    ColorPickerText.TextColor3 = self.Config.Theme.Text
    ColorPickerText.TextXAlignment = Enum.TextXAlignment.Left
    ColorPickerText.Parent = ColorPickerFrame
    
    -- Color display
    local ColorDisplay = Instance.new("Frame")
    ColorDisplay.Name = "ColorDisplay"
    ColorDisplay.Size = UDim2.new(0, 30, 0, 20)
    ColorDisplay.Position = UDim2.new(1, -40, 0.5, -10)
    ColorDisplay.BackgroundColor3 = colorPicker.Value
    ColorDisplay.BorderSizePixel = 0
    ColorDisplay.Parent = ColorPickerFrame
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 4)
    UICorner.Parent = ColorDisplay
    
    -- Color picker panel
    local PickerPanel = Instance.new("Frame")
    PickerPanel.Name = "PickerPanel"
    PickerPanel.Size = UDim2.new(1, -20, 0, 120)
    PickerPanel.Position = UDim2.new(0, 10, 0, 40)
    PickerPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    PickerPanel.BorderSizePixel = 0
    PickerPanel.Visible = false
    PickerPanel.Parent = ColorPickerFrame
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 4)
    UICorner2.Parent = PickerPanel
    
    -- RGB sliders
    local function createColorSlider(color, defaultValue, yPos)
        local slider = {}
        
        -- Slider background
        local SliderBG = Instance.new("Frame")
        SliderBG.Name = color .. "SliderBG"
        SliderBG.Size = UDim2.new(1, -20, 0, 20)
        SliderBG.Position = UDim2.new(0, 10, 0, yPos)
        SliderBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        SliderBG.BorderSizePixel = 0
        SliderBG.Parent = PickerPanel
        
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 4)
        UICorner.Parent = SliderBG
        
        -- Slider label
        local SliderLabel = Instance.new("TextLabel")
        SliderLabel.Name = "SliderLabel"
        SliderLabel.Size = UDim2.new(0, 20, 1, 0)
        SliderLabel.BackgroundTransparency = 1
        SliderLabel.Text = color
        SliderLabel.Font = Enum.Font.GothamBold
        SliderLabel.TextSize = 12
        SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        SliderLabel.TextXAlignment = Enum.TextXAlignment.Center
        SliderLabel.Parent = SliderBG
        
        -- Slider fill
        local SliderFill = Instance.new("Frame")
        SliderFill.Name = "SliderFill"
        SliderFill.Size = UDim2.new(defaultValue/255, 0, 1, 0)
        SliderFill.BackgroundColor3 = Color3.fromRGB(
            color == "R" and 255 or 40,
            color == "G" and 255 or 40,
            color == "B" and 255 or 40
        )
        SliderFill.BorderSizePixel = 0
        SliderFill.Parent = SliderBG
        
        local UICorner2 = Instance.new("UICorner")
        UICorner2.CornerRadius = UDim.new(0, 4)
        UICorner2.Parent = SliderFill
        
        -- Value display
        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Name = "ValueLabel"
        ValueLabel.Size = UDim2.new(0, 30, 1, 0)
        ValueLabel.Position = UDim2.new(1, -30, 0, 0)
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Text = tostring(defaultValue)
        ValueLabel.Font = Enum.Font.Gotham
        ValueLabel.TextSize = 12
        ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
        ValueLabel.Parent = SliderBG
        
        -- Slider interaction
        local SliderInteract = Instance.new("TextButton")
        SliderInteract.Name = "SliderInteract"
        SliderInteract.Size = UDim2.new(1, 0, 1, 0)
        SliderInteract.BackgroundTransparency = 1
        SliderInteract.Text = ""
        SliderInteract.Parent = SliderBG
        
        -- Slider functionality
        local isDragging = false
        
        local function updateSlider(input)
            local sizeX = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
            local value = math.floor(sizeX * 255)
            
            -- Update UI
            SliderFill.Size = UDim2.new(sizeX, 0, 1, 0)
            ValueLabel.Text = tostring(value)
            
            -- Update color
            local r = colorPicker.Value.R * 255
            local g = colorPicker.Value.G * 255
            local b = colorPicker.Value.B * 255
            
            if color == "R" then r = value
            elseif color == "G" then g = value
            elseif color == "B" then b = value end
            
            colorPicker.Value = Color3.fromRGB(r, g, b)
            ColorDisplay.BackgroundColor3 = colorPicker.Value
            
            -- Call callback
            if callback then
                callback(colorPicker.Value)
            end
        end
        
        SliderInteract.MouseButton1Down:Connect(function(input)
            isDragging = true
            updateSlider(input)
        end)
        
        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and isDragging then
                isDragging = false
            end
        end)
        
        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
                updateSlider(input)
            end
        end)
        
        return slider
    end
    
    -- Create RGB sliders
    local rSlider = createColorSlider("R", colorPicker.Value.R * 255, 10)
    local gSlider = createColorSlider("G", colorPicker.Value.G * 255, 40)
    local bSlider = createColorSlider("B", colorPicker.Value.B * 255, 70)
    
    -- Done button
    local DoneButton = Instance.new("TextButton")
    DoneButton.Name = "DoneButton"
    DoneButton.Size = UDim2.new(1, -20, 0, 20)
    DoneButton.Position = UDim2.new(0, 10, 0, 100)
    DoneButton.BackgroundColor3 = self.Config.Theme.Accent
    DoneButton.BorderSizePixel = 0
    DoneButton.Text = "Done"
    DoneButton.Font = Enum.Font.GothamSemibold
    DoneButton.TextSize = 14
    DoneButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DoneButton.Parent = PickerPanel
    
    local UICorner3 = Instance.new("UICorner")
    UICorner3.CornerRadius = UDim.new(0, 4)
    UICorner3.Parent = DoneButton
    
    -- ColorPicker interaction
    local ColorPickerInteract = Instance.new("TextButton")
    ColorPickerInteract.Name = "ColorPickerInteract"
    ColorPickerInteract.Size = UDim2.new(1, 0, 0, 35)
    ColorPickerInteract.BackgroundTransparency = 1
    ColorPickerInteract.Text = ""
    ColorPickerInteract.Parent = ColorPickerFrame
    
    -- Toggle color picker
    function colorPicker:Toggle()
        colorPicker.Open = not colorPicker.Open
        
        if colorPicker.Open then
            ColorPickerFrame.Size = UDim2.new(1, 0, 0, 170)
            PickerPanel.Visible = true
        else
            ColorPickerFrame.Size = UDim2.new(1, 0, 0, 35)
            
            task.delay(self.Config.TweenInfo.Time, function()
                if not colorPicker.Open then
                    PickerPanel.Visible = false
                end
            end)
        end
        
        -- Update canvas size
        self:UpdateCanvasSize(window)
    end
    
    ColorPickerInteract.MouseButton1Click:Connect(function()
        colorPicker:Toggle()
    end)
    
    DoneButton.MouseButton1Click:Connect(function()
        colorPicker:Toggle()
    end)
    
    -- Hover effect
    ColorPickerInteract.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            ColorPickerFrame, 
            self.Config.TweenInfo, 
            {BackgroundColor3 = Color3.fromRGB(
                self.Config.Theme.Secondary.R * 255 + 20, 
                self.Config.Theme.Secondary.G * 255 + 20, 
                self.Config.Theme.Secondary.B * 255 + 20
            )}
        ):Play()
    end)
    
    ColorPickerInteract.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            ColorPickerFrame, 
            self.Config.TweenInfo, 
            {BackgroundColor3 = self.Config.Theme.Secondary}
        ):Play()
    end)
    
    -- ColorPicker methods
    function colorPicker:Set(color)
        colorPicker.Value = color
        ColorDisplay.BackgroundColor3 = color
        
        if callback then
            callback(color)
        end
    end
    
    -- Update canvas size
    self:UpdateCanvasSize(window)
    
    return colorPicker
end

-- Helper function to update container canvas size
function MyUILib:UpdateCanvasSize(window)
    task.wait() -- Wait for UI to update
    
    local contentSize = window.UIListLayout.AbsoluteContentSize
    window.ElementsContainer.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + 10)
end
function MyUILib:AddTabSystem(window)
    -- Clear existing elements
    for _, child in pairs(window.ElementsContainer:GetChildren()) do
        if child:IsA("UIListLayout") then
            continue
        end
        child:Destroy()
    end
    
    -- Create tab container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 0, 30)
    TabContainer.BackgroundColor3 = self.Config.Theme.Secondary
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = window.MainFrame
    
    -- Adjust content area
    window.ElementsContainer.Size = UDim2.new(1, -20, 1, -60)
    window.ElementsContainer.Position = UDim2.new(0, 10, 0, 40)
    
    -- Create tab buttons frame
    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.Size = UDim2.new(1, 0, 1, 0)
    TabButtons.BackgroundTransparency = 1
    TabButtons.Parent = TabContainer
    
    -- Tab buttons layout
    local TabButtonsLayout = Instance.new("UIListLayout")
    TabButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
    TabButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabButtonsLayout.Padding = UDim.new(0, 2)
    TabButtonsLayout.Parent = TabButtons
    
    -- Initialize tabs
    window.Tabs = {}
    window.ActiveTab = nil
    
    -- Update window
    return window
end

function MyUILib:CreateTab(window, name)
    if not window.Tabs then
        window = self:AddTabSystem(window)
    end
    
    local tab = {}
    tab.Name = name
    tab.Elements = {}
    
    -- Create tab button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = "Tab_" .. name
    TabButton.Size = UDim2.new(0, 100, 1, 0)
    TabButton.BackgroundColor3 = self.Config.Theme.Secondary
    TabButton.BorderSizePixel = 0
    TabButton.Text = name
    TabButton.Font = Enum.Font.GothamSemibold
    TabButton.TextSize = 12
    TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabButton.Parent = window.TabButtons
    
    -- Tab page
    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Name = "TabPage_" .. name
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.BackgroundTransparency = 1
    TabPage.ScrollBarThickness = 2
    TabPage.ScrollBarImageColor3 = self.Config.Theme.Accent
    TabPage.Visible = false
    TabPage.Parent = window.ElementsContainer
    
    -- Elements layout
    local ElementsLayout = Instance.new("UIListLayout")
    ElementsLayout.Padding = UDim.new(0, 10)
    ElementsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ElementsLayout.Parent = TabPage
    
    -- Store tab data
    tab.Button = TabButton
    tab.Page = TabPage
    tab.Layout = ElementsLayout
    
    -- Tab selection
    TabButton.MouseButton1Click:Connect(function()
        self:SelectTab(window, tab)
    end)
    
    -- Add tab to window
    table.insert(window.Tabs, tab)
    
    -- Select first tab by default
    if #window.Tabs == 1 then
        self:SelectTab(window, tab)
    end
    
    return tab
end

function MyUILib:SelectTab(window, tab)
    -- Deselect all tabs
    for _, t in pairs(window.Tabs) do
        t.Page.Visible = false
        t.Button.BackgroundColor3 = self.Config.Theme.Secondary
        t.Button.TextColor3 = Color3.fromRGB(180, 180, 180)
    end
    
    -- Select target tab
    tab.Page.Visible = true
    tab.Button.BackgroundColor3 = self.Config.Theme.Accent
    tab.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    
    window.ActiveTab = tab
end
function MyUILib:SetTheme(theme)
    -- Update theme configuration
    self.Config.Theme = theme
    
    -- Update existing windows with new theme
    for _, window in pairs(self.Windows) do
        -- Update main elements
        window.MainFrame.BackgroundColor3 = theme.Background
        
        -- Update title bar
        local titleBar = window.MainFrame:FindFirstChild("TitleBar")
        if titleBar then
            titleBar.BackgroundColor3 = theme.Secondary
            
            local titleText = titleBar:FindFirstChild("Title")
            if titleText then
                titleText.TextColor3 = theme.Text
            end
            
            local closeButton = titleBar:FindFirstChild("CloseButton")
            if closeButton then
                closeButton.TextColor3 = theme.Text
            end
        end
        
        -- More theme updates for other elements...
    end
end

-- Predefined themes
MyUILib.Themes = {
    Dark = {
        Background = Color3.fromRGB(30, 30, 30),
        Accent = Color3.fromRGB(0, 120, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Secondary = Color3.fromRGB(50, 50, 50)
    },
    Light = {
        Background = Color3.fromRGB(230, 230, 230),
        Accent = Color3.fromRGB(0, 100, 220),
        Text = Color3.fromRGB(20, 20, 20),
        Secondary = Color3.fromRGB(200, 200, 200)
    },
    Midnight = {
        Background = Color3.fromRGB(25, 25, 35),
        Accent = Color3.fromRGB(120, 80, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Secondary = Color3.fromRGB(40, 40, 60)
    }
}
function MyUILib:Notify(title, text, duration)
    duration = duration or 3
    
    -- Create notification container if needed
    if not self.NotifyContainer then
        self.NotifyContainer = Instance.new("Frame")
        self.NotifyContainer.Name = "NotifyContainer"
        self.NotifyContainer.Size = UDim2.new(0, 250, 1, 0)
        self.NotifyContainer.Position = UDim2.new(1, -260, 0, 0)
        self.NotifyContainer.BackgroundTransparency = 1
        self.NotifyContainer.Parent = game:GetService("CoreGui"):FindFirstChild(self.Config.Name) or game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild(self.Config.Name)
        
        local notifyLayout = Instance.new("UIListLayout")
        notifyLayout.Padding = UDim.new(0, 10)
        notifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        notifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        notifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
        notifyLayout.Parent = self.NotifyContainer
    end
    
    -- Create notification
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(1, -20, 0, 80)
    notification.BackgroundColor3 = self.Config.Theme.Background
    notification.BorderSizePixel = 0
    notification.Position = UDim2.new(1, 0, 0, 0)
    notification.Parent = self.NotifyContainer
    
    local notifyCorner = Instance.new("UICorner")
    notifyCorner.CornerRadius = UDim.new(0, 6)
    notifyCorner.Parent = notification
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextColor3 = self.Config.Theme.Text
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notification
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Text"
    textLabel.Size = UDim2.new(1, -20, 0, 40)
    textLabel.Position = UDim2.new(0, 10, 0, 35)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 14
    textLabel.TextWrapped = true
    textLabel.TextColor3 = self.Config.Theme.Text
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextYAlignment = Enum.TextYAlignment.Top
    textLabel.Parent = notification
    
-- Animation for the notification system
notification:TweenPosition(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)

-- Create a timer to auto-dismiss the notification
task.spawn(function()
    task.wait(duration)
    
    -- Fade out animation
    notification:TweenPosition(UDim2.new(1, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.5, true)
    
    -- Remove notification after animation
    task.wait(0.5)
    notification:Destroy()
end)
function MyUILib:SetKeybind(key)
    self.Config.ToggleKey = key
    
    -- Remove existing connection if there is one
    if self.KeybindConnection then
        self.KeybindConnection:Disconnect()
    end
    
    -- Create new connection
    self.KeybindConnection = game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.KeyCode == key then
            self:ToggleUI()
        end
    end)
end

function MyUILib:ToggleUI()
    for _, window in pairs(self.Windows) do
        window.MainFrame.Visible = not window.MainFrame.Visible
    end
end
return MyUILib
