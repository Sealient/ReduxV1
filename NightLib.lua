-- Rodus UI Library
local Rodus = {}

function Rodus:CreateMain(title)
	local player = game.Players.LocalPlayer
	local parent = player:WaitForChild("PlayerGui")
	
	-- Destroy existing UI with same name
	local destroyIfExist = parent:GetChildren()
	for _, gui in pairs(destroyIfExist) do
		if gui.Name == title then
			print("Destroyed "..tostring(title)..": Already existed")
			gui:Destroy()
		end
	end

	-- Main UI Instances
	local Rodus = Instance.new("ScreenGui")
	local Top = Instance.new("Frame")
	local Title = Instance.new("TextLabel")
	local Container = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")
	local Minimize = Instance.new("TextButton")

	-- ScreenGui Setup
	Rodus.Name = tostring(title)
	Rodus.Parent = parent
	Rodus.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	-- Top Frame
	Top.Name = "Top"
	Top.Parent = Rodus
	Top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Top.BackgroundTransparency = 0.500
	Top.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Top.BorderSizePixel = 4
	Top.Position = UDim2.new(0, 15, 0, 15)
	Top.Size = UDim2.new(0, 193, 0, 27)

	-- Title
	Title.Name = "Title"
	Title.Parent = Top
	Title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Title.BackgroundTransparency = 0.350
	Title.BorderSizePixel = 0
	Title.Size = UDim2.new(0, 193, 0, 27)
	Title.Font = Enum.Font.JosefinSans
	Title.Text = " "..title
	Title.TextColor3 = Color3.fromRGB(0, 255, 0)
	Title.TextSize = 14.000
	Title.TextXAlignment = Enum.TextXAlignment.Left

	-- Container
	Container.Name = "Container"
	Container.Parent = Top
	Container.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Container.BackgroundTransparency = 0.500
	Container.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Container.BorderSizePixel = 4
	Container.Position = UDim2.new(0, 0, 1.29629624, 0)
	Container.Size = UDim2.new(0, 193, 0, 24)

	UIListLayout.Parent = Container
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	-- Minimize Button
	Minimize.Name = "Minimize"
	Minimize.Parent = Top
	Minimize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Minimize.BackgroundTransparency = 1.000
	Minimize.Position = UDim2.new(0.906735778, 0, 0.185185179, 0)
	Minimize.Size = UDim2.new(0, 18, 0, 17)
	Minimize.Font = Enum.Font.SourceSans
	Minimize.Text = "-"
	Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
	Minimize.TextSize = 14.000
	
	-- Minimize functionality
	local tog_gled = false
	Minimize.MouseButton1Down:Connect(function()
		tog_gled = not tog_gled
		if tog_gled then 
			Minimize.Text = "+" 
			Container.Visible = false 
		else 
			Minimize.Text = "-" 
			Container.Visible = true 
		end
	end)

	-- Toggle visibility with RightControl
	local function onKeyPress(inputObject, gameProcessedEvent)
		if inputObject.KeyCode == Enum.KeyCode.RightControl then
			Top.Visible = not Top.Visible
		end
	end
	game:GetService("UserInputService").InputBegan:Connect(onKeyPress)

	-- Store UI customization settings
	local UISettings = {
		BackgroundTransparency = 0.5,
		TextColor = Color3.fromRGB(0, 255, 0),
		BackgroundColor = Color3.fromRGB(0, 0, 0),
		TextSize = 14,
		Enabled = true
	}

	-- Function to apply UI settings
	local function applyUISettings()
		Top.BackgroundTransparency = UISettings.BackgroundTransparency
		Container.BackgroundTransparency = UISettings.BackgroundTransparency
		Title.TextColor3 = UISettings.TextColor
		Title.TextSize = UISettings.TextSize
		
		-- Apply to all tabs and elements
		for _, child in pairs(Container:GetChildren()) do
			if child:IsA("TextButton") then
				child.TextSize = UISettings.TextSize
				if child:FindFirstChild("Arrow") then
					child.Arrow.TextSize = UISettings.TextSize
				end
			end
		end
	end

	-- UI Functions
	local uiFunctions = {}
	local customTabs = {} -- Store custom tabs to maintain order

	function uiFunctions:CreateTab(text)
		local Tab = Instance.new("TextButton")
		local Arrow = Instance.new("TextLabel")

		Tab.Name = text
		Tab.Parent = Container
		Tab.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Tab.BackgroundTransparency = 1.000
		Tab.Size = UDim2.new(0, 193, 0, 24)
		Tab.Font = Enum.Font.JosefinSans
		Tab.Text = " "..text
		Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
		Tab.TextSize = UISettings.TextSize
		Tab.TextXAlignment = Enum.TextXAlignment.Left

		Arrow.Name = "Arrow"
		Arrow.Parent = Tab
		Arrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Arrow.BackgroundTransparency = 1.000
		Arrow.Position = UDim2.new(0.907, 0, 0, 0)
		Arrow.Size = UDim2.new(0, 18, 0, 21)
		Arrow.Font = Enum.Font.SourceSans
		Arrow.Text = ">>"
		Arrow.TextColor3 = Color3.fromRGB(255, 255, 255)
		Arrow.TextScaled = true
		Arrow.TextSize = UISettings.TextSize
		Arrow.TextWrapped = true
		
		-- Update container size
		Container.Size = UDim2.new(0, 193, 0, UIListLayout.AbsoluteContentSize.Y)
		
		-- Tab Container
		local TabContainer = Instance.new("Frame")
		TabContainer.Name = "TabContainer"
		TabContainer.Parent = Tab
		TabContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		TabContainer.BackgroundTransparency = UISettings.BackgroundTransparency
		TabContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabContainer.BorderSizePixel = 4
		TabContainer.Position = UDim2.new(1.0569948, 0, 0, 0)
		TabContainer.Visible = false
		
		local UIListLayout2 = Instance.new("UIListLayout")
		UIListLayout2.Parent = TabContainer
		UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder

		-- Tab click functionality
		Tab.MouseButton1Down:Connect(function()
			-- Check if this tab is currently open
			local wasOpen = TabContainer.Visible
			
			-- First, reset EVERY tab to white and close their containers
			for _, child in pairs(Container:GetChildren()) do
				if child:IsA("TextButton") then
					-- Reset text color to white
					child.TextColor3 = Color3.new(255, 255, 255)
					
					-- Reset arrow color to white if it exists
					local arrow = child:FindFirstChild("Arrow")
					if arrow then
						arrow.TextColor3 = Color3.new(255, 255, 255)
					end
					
					-- Close the tab container
					local tabContainer = child:FindFirstChild("TabContainer")
					if tabContainer then
						tabContainer.Visible = false
					end
				end
			end
			
			-- If this tab wasn't open before, open it and set to green
			if not wasOpen then
				TabContainer.Visible = true
				Tab.TextColor3 = UISettings.TextColor
				if Tab.Arrow then
					Tab.Arrow.TextColor3 = UISettings.TextColor
				end
			end
		end)

		-- Tab-specific functions
		local tabFunctions = {}

		function tabFunctions:CreateButton(buttonText, note, callback)
			local Button = Instance.new("TextButton")
			local Note = Instance.new("TextLabel")

			Button.Name = buttonText
			Button.Parent = TabContainer
			Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			Button.BackgroundTransparency = 1.000
			Button.Size = UDim2.new(0, 193, 0, 24)
			Button.Font = Enum.Font.JosefinSans
			Button.Text = " "..buttonText
			Button.TextColor3 = Color3.fromRGB(255, 255, 255)
			Button.TextSize = UISettings.TextSize
			Button.TextXAlignment = Enum.TextXAlignment.Left

			Button.MouseButton1Down:Connect(function()
				Button.TextColor3 = UISettings.TextColor
				task.wait(0.05)
				Button.TextColor3 = Color3.new(255, 255, 255)
				if callback then
					pcall(callback)
				end
			end)

			Note.Name = "Note"
			Note.Parent = Button
			Note.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Note.BackgroundTransparency = 1.000
			Note.Position = UDim2.new(1.04145074, 0, 0, 0)
			Note.Size = UDim2.new(0, 193, 0, 24)
			Note.Font = Enum.Font.JosefinSans
			Note.Text = note or ""
			Note.TextColor3 = UISettings.TextColor
			Note.TextSize = UISettings.TextSize
			Note.TextXAlignment = Enum.TextXAlignment.Left
			Note.Visible = false
			
			Button.MouseEnter:Connect(function()
				Note.Visible = true
			end)

			Button.MouseLeave:Connect(function()
				Note.Visible = false
			end)
			
			-- Update sizes
			TabContainer.Size = UDim2.new(0, 193, 0, UIListLayout2.AbsoluteContentSize.Y)
		end

		function tabFunctions:CreateLabel(labelText, color3)
			local Label = Instance.new("TextLabel")

			Label.Name = labelText
			Label.Parent = TabContainer
			Label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			Label.BackgroundTransparency = 1.000
			Label.Size = UDim2.new(0, 193, 0, 24)
			Label.Font = Enum.Font.JosefinSans
			Label.Text = " "..labelText
			Label.TextColor3 = color3 or Color3.fromRGB(255, 255, 255)
			Label.TextSize = UISettings.TextSize
			Label.TextXAlignment = Enum.TextXAlignment.Left
			
			TabContainer.Size = UDim2.new(0, 193, 0, UIListLayout2.AbsoluteContentSize.Y)
		end

		function tabFunctions:CreateToggle(buttonText, note, callback)
			local Button = Instance.new("TextButton")
			local Note = Instance.new("TextLabel")
			local Toggle = Instance.new("BoolValue")
			
			Button.Name = buttonText
			Button.Parent = TabContainer
			Toggle.Parent = Button
			Toggle.Name = "Toggled"
			Toggle.Value = false

			Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			Button.BackgroundTransparency = 1.000
			Button.Size = UDim2.new(0, 193, 0, 24)
			Button.Font = Enum.Font.JosefinSans
			Button.Text = " "..buttonText
			Button.TextColor3 = Color3.fromRGB(255, 255, 255)
			Button.TextSize = UISettings.TextSize
			Button.TextXAlignment = Enum.TextXAlignment.Left

			Button.MouseEnter:Connect(function()
				if Note then
					Note.Visible = true
				end
			end)

			Button.MouseLeave:Connect(function()
				if Note then
					Note.Visible = false
				end
			end)

			Button.MouseButton1Down:Connect(function()
				Toggle.Value = not Toggle.Value
				if Toggle.Value then
					Button.TextColor3 = UISettings.TextColor
				else
					Button.TextColor3 = Color3.new(255, 255, 255)
				end
				if callback then
					pcall(callback, Toggle.Value)
				end
			end)

			Note.Name = "Note"
			Note.Parent = Button
			Note.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Note.BackgroundTransparency = 1.000
			Note.Position = UDim2.new(1.04145074, 0, 0, 0)
			Note.Size = UDim2.new(0, 193, 0, 24)
			Note.Font = Enum.Font.JosefinSans
			Note.Text = note or ""
			Note.TextColor3 = UISettings.TextColor
			Note.TextSize = UISettings.TextSize
			Note.TextXAlignment = Enum.TextXAlignment.Left
			Note.Visible = false
			
			TabContainer.Size = UDim2.new(0, 193, 0, UIListLayout2.AbsoluteContentSize.Y)
			
			return Toggle
		end

		function tabFunctions:CreateSideDropButton(dropText, list, callback)
			local SideDrop = Instance.new("TextButton")
			local Arrow = Instance.new("TextButton")
			local DropContainer = Instance.new("Frame")
			local DropUIListLayout = Instance.new("UIListLayout")

			SideDrop.Name = dropText
			SideDrop.Parent = TabContainer
			SideDrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			SideDrop.BackgroundTransparency = 1.000
			SideDrop.Size = UDim2.new(0, 193, 0, 24)
			SideDrop.Font = Enum.Font.JosefinSans
			SideDrop.Text = " "..dropText
			SideDrop.TextColor3 = Color3.fromRGB(255, 255, 255)
			SideDrop.TextSize = UISettings.TextSize
			SideDrop.TextXAlignment = Enum.TextXAlignment.Left

			Arrow.Name = "Arrow"
			Arrow.Parent = SideDrop
			Arrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Arrow.BackgroundTransparency = 1.000
			Arrow.Position = UDim2.new(0.906735778, 0, 0, 0)
			Arrow.Size = UDim2.new(0, 18, 0, 21)
			Arrow.Font = Enum.Font.SourceSans
			Arrow.Text = ">>"
			Arrow.TextColor3 = Color3.fromRGB(255, 255, 255)
			Arrow.TextScaled = true
			Arrow.TextSize = UISettings.TextSize
			Arrow.TextWrapped = true

			DropContainer.Name = "DropContainer"
			DropContainer.Parent = SideDrop
			DropContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			DropContainer.BackgroundTransparency = UISettings.BackgroundTransparency
			DropContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
			DropContainer.BorderSizePixel = 4
			DropContainer.Position = UDim2.new(1.08290148, 0, 0, 0)
			DropContainer.Size = UDim2.new(0, 193, 0, 0)
			DropContainer.Visible = false

			DropUIListLayout.Parent = DropContainer
			DropUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

			-- Dropdown toggle
			SideDrop.MouseButton1Down:Connect(function()
				local allDropContainers = TabContainer:GetDescendants()
				for _, element in pairs(allDropContainers) do
					if element.Name == "DropContainer" and element ~= DropContainer then
						element.Visible = false
						if element.Parent:FindFirstChild("TextColor3") then
							element.Parent.TextColor3 = Color3.new(255, 255, 255)
						end
						if element.Parent:FindFirstChild("Arrow") then
							element.Parent.Arrow.TextColor3 = Color3.new(255, 255, 255)
						end
					end
				end

				DropContainer.Visible = not DropContainer.Visible
				if DropContainer.Visible then
					SideDrop.TextColor3 = UISettings.TextColor
					Arrow.TextColor3 = UISettings.TextColor
				else
					SideDrop.TextColor3 = Color3.new(255, 255, 255)
					Arrow.TextColor3 = Color3.new(255, 255, 255)
				end
			end)

			-- Create dropdown items
			for _, option in pairs(list or {}) do
				local Button = Instance.new("TextButton")
				Button.Name = option
				Button.Parent = DropContainer
				Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				Button.BackgroundTransparency = 1.000
				Button.Size = UDim2.new(0, 193, 0, 24)
				Button.Font = Enum.Font.JosefinSans
				Button.Text = " "..option
				Button.TextColor3 = Color3.fromRGB(255, 255, 255)
				Button.TextSize = UISettings.TextSize
				Button.TextXAlignment = Enum.TextXAlignment.Left

				Button.MouseButton1Down:Connect(function()
					Button.TextColor3 = UISettings.TextColor
					task.wait(0.05)
					Button.TextColor3 = Color3.new(255, 255, 255)
					if callback then
						pcall(callback, option)
					end
				end)
			end

			-- Update sizes
			DropContainer.Size = UDim2.new(0, 193, 0, DropUIListLayout.AbsoluteContentSize.Y)
			TabContainer.Size = UDim2.new(0, 193, 0, UIListLayout2.AbsoluteContentSize.Y)
		end

		function tabFunctions:CreateTextBox(buttonText, placeholderText, callback)
			local TextBoxBtn = Instance.new("TextButton")
			local Arrow = Instance.new("TextButton")
			local Side = Instance.new("Frame")
			local Box = Instance.new("TextBox")
			local Hover = Instance.new("Frame")

			TextBoxBtn.Name = buttonText
			TextBoxBtn.Parent = TabContainer
			TextBoxBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			TextBoxBtn.BackgroundTransparency = 1.000
			TextBoxBtn.Size = UDim2.new(0, 193, 0, 24)
			TextBoxBtn.Font = Enum.Font.JosefinSans
			TextBoxBtn.Text = " "..buttonText
			TextBoxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			TextBoxBtn.TextSize = UISettings.TextSize
			TextBoxBtn.TextXAlignment = Enum.TextXAlignment.Left

			Arrow.Name = "Arrow"
			Arrow.Parent = TextBoxBtn
			Arrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Arrow.BackgroundTransparency = 1.000
			Arrow.Position = UDim2.new(0.906735778, 0, 0, 0)
			Arrow.Size = UDim2.new(0, 18, 0, 21)
			Arrow.Font = Enum.Font.SourceSans
			Arrow.Text = ">>"
			Arrow.TextColor3 = Color3.fromRGB(255, 255, 255)
			Arrow.TextScaled = true
			Arrow.TextSize = UISettings.TextSize
			Arrow.TextWrapped = true

			Side.Name = "Side"
			Side.Parent = TextBoxBtn
			Side.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			Side.BackgroundTransparency = UISettings.BackgroundTransparency
			Side.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Side.BorderSizePixel = 4
			Side.Position = UDim2.new(1.08290148, 0, 0, 0)
			Side.Size = UDim2.new(0, 193, 0, 24)
			Side.Visible = false

			Box.Name = "Box"
			Box.Parent = Side
			Box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Box.BackgroundTransparency = 1.000
			Box.Size = UDim2.new(0, 193, 0, 24)
			Box.Font = Enum.Font.JosefinSans
			Box.Text = ""
			Box.TextColor3 = Color3.fromRGB(255, 255, 255)
			Box.TextSize = UISettings.TextSize
			Box.TextWrapped = true
			Box.PlaceholderText = placeholderText or "Enter text..."

			Hover.Name = "Hover"
			Hover.Parent = TextBoxBtn
			Hover.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Hover.BackgroundTransparency = 1.000
			Hover.Size = UDim2.new(0, 209, 0, 32)

			-- Hover functionality
			Hover.MouseEnter:Connect(function()
				Side.Visible = true
			end)

			Hover.MouseLeave:Connect(function()
				Side.Visible = false
			end)

			-- Submit on button click
			TextBoxBtn.MouseButton1Down:Connect(function()
				TextBoxBtn.TextColor3 = UISettings.TextColor
				task.wait(0.05)
				TextBoxBtn.TextColor3 = Color3.new(255, 255, 255)
				if callback then
					pcall(callback, Box.Text)
				end
			end)

			-- Submit on Enter key
			Box.FocusLost:Connect(function(enterPressed)
				if enterPressed and callback then
					pcall(callback, Box.Text)
				end
			end)

			TabContainer.Size = UDim2.new(0, 193, 0, UIListLayout2.AbsoluteContentSize.Y)
		end

		-- Store custom tabs for ordering
		table.insert(customTabs, {Tab = Tab, Functions = tabFunctions})
		
		return tabFunctions
	end

	-- Create mandatory Settings tab (always last)
	local function createSettingsTab()
		local SettingsTab = Instance.new("TextButton")
		local Arrow = Instance.new("TextLabel")

		SettingsTab.Name = "Settings"
		SettingsTab.Parent = Container
		SettingsTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		SettingsTab.BackgroundTransparency = 1.000
		SettingsTab.Size = UDim2.new(0, 193, 0, 24)
		SettingsTab.Font = Enum.Font.JosefinSans
		SettingsTab.Text = " Settings"
		SettingsTab.TextColor3 = Color3.fromRGB(255, 255, 255)
		SettingsTab.TextSize = UISettings.TextSize
		SettingsTab.TextXAlignment = Enum.TextXAlignment.Left

		Arrow.Name = "Arrow"
		Arrow.Parent = SettingsTab
		Arrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Arrow.BackgroundTransparency = 1.000
		Arrow.Position = UDim2.new(0.907, 0, 0, 0)
		Arrow.Size = UDim2.new(0, 18, 0, 21)
		Arrow.Font = Enum.Font.SourceSans
		Arrow.Text = ">>"
		Arrow.TextColor3 = Color3.fromRGB(255, 255, 255)
		Arrow.TextScaled = true
		Arrow.TextSize = UISettings.TextSize
		Arrow.TextWrapped = true
		
		-- Settings Tab Container
		local SettingsContainer = Instance.new("Frame")
		SettingsContainer.Name = "TabContainer"
		SettingsContainer.Parent = SettingsTab
		SettingsContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		SettingsContainer.BackgroundTransparency = UISettings.BackgroundTransparency
		SettingsContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SettingsContainer.BorderSizePixel = 4
		SettingsContainer.Position = UDim2.new(1.0569948, 0, 0, 0)
		SettingsContainer.Visible = false
		
		local SettingsUIListLayout = Instance.new("UIListLayout")
		SettingsUIListLayout.Parent = SettingsContainer
		SettingsUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

		-- Settings Tab click functionality
		SettingsTab.MouseButton1Down:Connect(function()
			local wasOpen = SettingsContainer.Visible
			
			-- Close ALL tabs
			for _, child in pairs(Container:GetChildren()) do
				if child:IsA("TextButton") then
					child.TextColor3 = Color3.new(255, 255, 255)
					local arrow = child:FindFirstChild("Arrow")
					if arrow then
						arrow.TextColor3 = Color3.new(255, 255, 255)
					end
					local tabContainer = child:FindFirstChild("TabContainer")
					if tabContainer then
						tabContainer.Visible = false
					end
				end
			end
			
			if not wasOpen then
				SettingsContainer.Visible = true
				SettingsTab.TextColor3 = UISettings.TextColor
				SettingsTab.Arrow.TextColor3 = UISettings.TextColor
			end
		end)

		-- UI Customization Settings
		
		-- Background Transparency
		local transparencyToggle = SettingsContainer:FindFirstChild("Transparency") or Instance.new("TextButton")
		transparencyToggle.Name = "Transparency"
		transparencyToggle.Parent = SettingsContainer
		transparencyToggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		transparencyToggle.BackgroundTransparency = 1.000
		transparencyToggle.Size = UDim2.new(0, 193, 0, 24)
		transparencyToggle.Font = Enum.Font.JosefinSans
		transparencyToggle.Text = " Transparency: "..UISettings.BackgroundTransparency
		transparencyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
		transparencyToggle.TextSize = UISettings.TextSize
		transparencyToggle.TextXAlignment = Enum.TextXAlignment.Left
		
		transparencyToggle.MouseButton1Down:Connect(function()
			UISettings.BackgroundTransparency = UISettings.BackgroundTransparency == 0.5 and 0.2 or 0.5
			transparencyToggle.Text = " Transparency: "..UISettings.BackgroundTransparency
			applyUISettings()
		end)

		-- Text Color
		local colorOptions = {"Green", "Blue", "Red", "Yellow", "White"}
		local colorMap = {
			Green = Color3.fromRGB(0, 255, 0),
			Blue = Color3.fromRGB(0, 150, 255),
			Red = Color3.fromRGB(255, 50, 50),
			Yellow = Color3.fromRGB(255, 255, 0),
			White = Color3.fromRGB(255, 255, 255)
		}
		
		local currentColor = "Green"
		local colorToggle = SettingsContainer:FindFirstChild("Text Color") or Instance.new("TextButton")
		colorToggle.Name = "Text Color"
		colorToggle.Parent = SettingsContainer
		colorToggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		colorToggle.BackgroundTransparency = 1.000
		colorToggle.Size = UDim2.new(0, 193, 0, 24)
		colorToggle.Font = Enum.Font.JosefinSans
		colorToggle.Text = " Text Color: "..currentColor
		colorToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
		colorToggle.TextSize = UISettings.TextSize
		colorToggle.TextXAlignment = Enum.TextXAlignment.Left
		
		colorToggle.MouseButton1Down:Connect(function()
			local currentIndex = table.find(colorOptions, currentColor) or 1
			local nextIndex = (currentIndex % #colorOptions) + 1
			currentColor = colorOptions[nextIndex]
			UISettings.TextColor = colorMap[currentColor]
			colorToggle.Text = " Text Color: "..currentColor
			colorToggle.TextColor3 = UISettings.TextColor
			applyUISettings()
		end)

		-- Text Size
		local sizeToggle = SettingsContainer:FindFirstChild("Text Size") or Instance.new("TextButton")
		sizeToggle.Name = "Text Size"
		sizeToggle.Parent = SettingsContainer
		sizeToggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		sizeToggle.BackgroundTransparency = 1.000
		sizeToggle.Size = UDim2.new(0, 193, 0, 24)
		sizeToggle.Font = Enum.Font.JosefinSans
		sizeToggle.Text = " Text Size: "..UISettings.TextSize
		sizeToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
		sizeToggle.TextSize = UISettings.TextSize
		sizeToggle.TextXAlignment = Enum.TextXAlignment.Left
		
		sizeToggle.MouseButton1Down:Connect(function()
			UISettings.TextSize = UISettings.TextSize == 14 and 16 or 14
			sizeToggle.Text = " Text Size: "..UISettings.TextSize
			sizeToggle.TextSize = UISettings.TextSize
			applyUISettings()
		end)

		-- Reset to Default
		local resetBtn = SettingsContainer:FindFirstChild("Reset Defaults") or Instance.new("TextButton")
		resetBtn.Name = "Reset Defaults"
		resetBtn.Parent = SettingsContainer
		resetBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		resetBtn.BackgroundTransparency = 1.000
		resetBtn.Size = UDim2.new(0, 193, 0, 24)
		resetBtn.Font = Enum.Font.JosefinSans
		resetBtn.Text = " Reset to Defaults"
		resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		resetBtn.TextSize = UISettings.TextSize
		resetBtn.TextXAlignment = Enum.TextXAlignment.Left
		
		resetBtn.MouseButton1Down:Connect(function()
			UISettings.BackgroundTransparency = 0.5
			UISettings.TextColor = Color3.fromRGB(0, 255, 0)
			UISettings.TextSize = 14
			currentColor = "Green"
			
			transparencyToggle.Text = " Transparency: "..UISettings.BackgroundTransparency
			colorToggle.Text = " Text Color: "..currentColor
			colorToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
			sizeToggle.Text = " Text Size: "..UISettings.TextSize
			sizeToggle.TextSize = UISettings.TextSize
			
			applyUISettings()
		end)

		-- Destroy UI Button
		local destroyBtn = SettingsContainer:FindFirstChild("Destroy UI") or Instance.new("TextButton")
		destroyBtn.Name = "Destroy UI"
		destroyBtn.Parent = SettingsContainer
		destroyBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		destroyBtn.BackgroundTransparency = 1.000
		destroyBtn.Size = UDim2.new(0, 193, 0, 24)
		destroyBtn.Font = Enum.Font.JosefinSans
		destroyBtn.Text = " DESTROY UI"
		destroyBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
		destroyBtn.TextSize = UISettings.TextSize
		destroyBtn.TextXAlignment = Enum.TextXAlignment.Left
		
		destroyBtn.MouseButton1Down:Connect(function()
			Rodus:Destroy()
		end)

		-- Update container size
		SettingsContainer.Size = UDim2.new(0, 193, 0, SettingsUIListLayout.AbsoluteContentSize.Y)
		Container.Size = UDim2.new(0, 193, 0, UIListLayout.AbsoluteContentSize.Y)
	end

	-- Create settings tab immediately
	createSettingsTab()

	return uiFunctions
end

return Rodus
