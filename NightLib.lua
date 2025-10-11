-- Rodus UI Library for Executors
local Rodus = {}

-- Safe table clone function (works in executors)
local function tableClone(original)
	local copy = {}
	for key, value in pairs(original) do
		copy[key] = value
	end
	return copy
end

-- Default theme settings
local defaultSettings = {
	MainColor = Color3.fromRGB(0, 255, 0),
	BackgroundTransparency = 0.5,
	TextColor = Color3.fromRGB(255, 255, 255),
	Font = Enum.Font.JosefinSans,
	TextSize = 14,
	AnimationSpeed = 0.3
}

function Rodus:CreateMain(title)
	-- Use CoreGui for executors (works in most executors)
	local parent = game:GetService("CoreGui")
	
	-- Destroy existing UI with same name
	local destroyIfExist = parent:GetChildren()
	for _, gui in pairs(destroyIfExist) do
		if gui.Name == title then
			print("Destroyed "..tostring(title)..": Already existed")
			gui:Destroy()
		end
	end

	-- Current settings (start with defaults)
	local currentSettings = tableClone(defaultSettings)
	
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

	-- Apply settings function
	local function applySettings()
		-- Apply to main UI
		Top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Top.BackgroundTransparency = currentSettings.BackgroundTransparency
		Title.TextColor3 = currentSettings.MainColor
		Title.Font = currentSettings.Font
		Title.TextSize = currentSettings.TextSize
		
		-- Apply to all existing elements
		local function applyToDescendants(parentObj)
			for _, child in pairs(parentObj:GetDescendants()) do
				if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
					child.Font = currentSettings.Font
					child.TextSize = currentSettings.TextSize
					
					if child:IsA("TextLabel") and child.Name == "Title" then
						child.TextColor3 = currentSettings.MainColor
					elseif child:IsA("TextButton") and child.Parent == Container then
						if child.TextColor3 == Color3.new(0, 255, 0) or child.TextColor3 == defaultSettings.MainColor then
							child.TextColor3 = currentSettings.MainColor
						else
							child.TextColor3 = currentSettings.TextColor
						end
					elseif child:IsA("TextLabel") and child.Name == "Note" then
						child.TextColor3 = currentSettings.MainColor
					else
						child.TextColor3 = currentSettings.TextColor
					end
				end
				
				if child:IsA("Frame") then
					child.BackgroundTransparency = currentSettings.BackgroundTransparency
				end
			end
		end
		
		applyToDescendants(Rodus)
	end

	-- Top Frame
	Top.Name = "Top"
	Top.Parent = Rodus
	Top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Top.BackgroundTransparency = currentSettings.BackgroundTransparency
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
	Title.Font = currentSettings.Font
	Title.Text = " "..title
	Title.TextColor3 = currentSettings.MainColor
	Title.TextSize = currentSettings.TextSize
	Title.TextXAlignment = Enum.TextXAlignment.Left

	-- Container
	Container.Name = "Container"
	Container.Parent = Top
	Container.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Container.BackgroundTransparency = currentSettings.BackgroundTransparency
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
	Minimize.TextColor3 = currentSettings.TextColor
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

	-- UI Functions
	local uiFunctions = {}

	function uiFunctions:CreateTab(text)
		local Tab = Instance.new("TextButton")
		local Arrow = Instance.new("TextLabel")

		Tab.Name = text
		Tab.Parent = Container
		Tab.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		Tab.BackgroundTransparency = 1.000
		Tab.Size = UDim2.new(0, 193, 0, 24)
		Tab.Font = currentSettings.Font
		Tab.Text = " "..text
		Tab.TextColor3 = currentSettings.TextColor
		Tab.TextSize = currentSettings.TextSize
		Tab.TextXAlignment = Enum.TextXAlignment.Left

		Arrow.Name = "Arrow"
		Arrow.Parent = Tab
		Arrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Arrow.BackgroundTransparency = 1.000
		Arrow.Position = UDim2.new(0.907, 0, 0, 0)
		Arrow.Size = UDim2.new(0, 18, 0, 21)
		Arrow.Font = Enum.Font.SourceSans
		Arrow.Text = ">>"
		Arrow.TextColor3 = currentSettings.TextColor
		Arrow.TextScaled = true
		Arrow.TextSize = 14.000
		Arrow.TextWrapped = true
		
		-- Update container size
		Container.Size = UDim2.new(0, 193, 0, UIListLayout.AbsoluteContentSize.Y)
		
		-- Tab Container
		local TabContainer = Instance.new("Frame")
		TabContainer.Name = "TabContainer"
		TabContainer.Parent = Tab
		TabContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		TabContainer.BackgroundTransparency = currentSettings.BackgroundTransparency
		TabContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabContainer.BorderSizePixel = 4
		TabContainer.Position = UDim2.new(1.0569948, 0, 0, 0)
		TabContainer.Visible = false
		
		local UIListLayout2 = Instance.new("UIListLayout")
		UIListLayout2.Parent = TabContainer
		UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder

		-- Tab click functionality
		Tab.MouseButton1Down:Connect(function()
			local isCurrentlyOpen = TabContainer.Visible
			
			-- Close ALL tab containers and reset ALL colors first
			local allTabs = Container:GetDescendants()
			for _, element in pairs(allTabs) do
				if element.Name == "TabContainer" then
					element.Visible = false
				end
				if element:IsA("TextButton") and element.Parent == Container then
					element.TextColor3 = currentSettings.TextColor
					if element:FindFirstChild("Arrow") then
						element.Arrow.TextColor3 = currentSettings.TextColor
					end
				end
			end
			
			-- If this tab wasn't open before, open it
			if not isCurrentlyOpen then
				TabContainer.Visible = true
				Tab.TextColor3 = currentSettings.MainColor
				if Tab:FindFirstChild("Arrow") then
					Tab.Arrow.TextColor3 = currentSettings.MainColor
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
			Button.Font = currentSettings.Font
			Button.Text = " "..buttonText
			Button.TextColor3 = currentSettings.TextColor
			Button.TextSize = currentSettings.TextSize
			Button.TextXAlignment = Enum.TextXAlignment.Left

			Button.MouseButton1Down:Connect(function()
				Button.TextColor3 = currentSettings.MainColor
				wait(0.05)
				Button.TextColor3 = currentSettings.TextColor
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
			Note.Font = currentSettings.Font
			Note.Text = note or ""
			Note.TextColor3 = currentSettings.MainColor
			Note.TextSize = currentSettings.TextSize
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
			Label.Font = currentSettings.Font
			Label.Text = " "..labelText
			Label.TextColor3 = color3 or currentSettings.TextColor
			Label.TextSize = currentSettings.TextSize
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
			Button.Font = currentSettings.Font
			Button.Text = " "..buttonText
			Button.TextColor3 = currentSettings.TextColor
			Button.TextSize = currentSettings.TextSize
			Button.TextXAlignment = Enum.TextXAlignment.Left

			Button.MouseButton1Down:Connect(function()
				Toggle.Value = not Toggle.Value
				if Toggle.Value then
					Button.TextColor3 = currentSettings.MainColor
				else
					Button.TextColor3 = currentSettings.TextColor
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
			Note.Font = currentSettings.Font
			Note.Text = note or ""
			Note.TextColor3 = currentSettings.MainColor
			Note.TextSize = currentSettings.TextSize
			Note.TextXAlignment = Enum.TextXAlignment.Left
			Note.Visible = false
			
			Button.MouseEnter:Connect(function()
				Note.Visible = true
			end)

			Button.MouseLeave:Connect(function()
				Note.Visible = false
			end)
			
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
			SideDrop.Font = currentSettings.Font
			SideDrop.Text = " "..dropText
			SideDrop.TextColor3 = currentSettings.TextColor
			SideDrop.TextSize = currentSettings.TextSize
			SideDrop.TextXAlignment = Enum.TextXAlignment.Left

			Arrow.Name = "Arrow"
			Arrow.Parent = SideDrop
			Arrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Arrow.BackgroundTransparency = 1.000
			Arrow.Position = UDim2.new(0.906735778, 0, 0, 0)
			Arrow.Size = UDim2.new(0, 18, 0, 21)
			Arrow.Font = Enum.Font.SourceSans
			Arrow.Text = ">>"
			Arrow.TextColor3 = currentSettings.TextColor
			Arrow.TextScaled = true
			Arrow.TextSize = 14.000
			Arrow.TextWrapped = true

			DropContainer.Name = "DropContainer"
			DropContainer.Parent = SideDrop
			DropContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			DropContainer.BackgroundTransparency = currentSettings.BackgroundTransparency
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
				
				-- Close other dropdowns
				for _, element in pairs(allDropContainers) do
					if element.Name == "DropContainer" and element ~= DropContainer then
						element.Visible = false
						if element.Parent:FindFirstChild("TextColor3") then
							element.Parent.TextColor3 = currentSettings.TextColor
						end
						if element.Parent:FindFirstChild("Arrow") then
							element.Parent.Arrow.TextColor3 = currentSettings.TextColor
						end
					end
				end

				-- Toggle current dropdown
				DropContainer.Visible = not DropContainer.Visible
				if DropContainer.Visible then
					SideDrop.TextColor3 = currentSettings.MainColor
					Arrow.TextColor3 = currentSettings.MainColor
				else
					SideDrop.TextColor3 = currentSettings.TextColor
					Arrow.TextColor3 = currentSettings.TextColor
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
				Button.Font = currentSettings.Font
				Button.Text = " "..option
				Button.TextColor3 = currentSettings.TextColor
				Button.TextSize = currentSettings.TextSize
				Button.TextXAlignment = Enum.TextXAlignment.Left

				Button.MouseButton1Down:Connect(function()
					Button.TextColor3 = currentSettings.MainColor
					wait(0.05)
					Button.TextColor3 = currentSettings.TextColor
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
			TextBoxBtn.Font = currentSettings.Font
			TextBoxBtn.Text = " "..buttonText
			TextBoxBtn.TextColor3 = currentSettings.TextColor
			TextBoxBtn.TextSize = currentSettings.TextSize
			TextBoxBtn.TextXAlignment = Enum.TextXAlignment.Left

			Arrow.Name = "Arrow"
			Arrow.Parent = TextBoxBtn
			Arrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Arrow.BackgroundTransparency = 1.000
			Arrow.Position = UDim2.new(0.906735778, 0, 0, 0)
			Arrow.Size = UDim2.new(0, 18, 0, 21)
			Arrow.Font = Enum.Font.SourceSans
			Arrow.Text = ">>"
			Arrow.TextColor3 = currentSettings.TextColor
			Arrow.TextScaled = true
			Arrow.TextSize = 14.000
			Arrow.TextWrapped = true

			Side.Name = "Side"
			Side.Parent = TextBoxBtn
			Side.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			Side.BackgroundTransparency = currentSettings.BackgroundTransparency
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
			Box.Font = currentSettings.Font
			Box.Text = ""
			Box.TextColor3 = currentSettings.TextColor
			Box.TextSize = currentSettings.TextSize
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
				TextBoxBtn.TextColor3 = currentSettings.MainColor
				wait(0.05)
				TextBoxBtn.TextColor3 = currentSettings.TextColor
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

		return tabFunctions
	end

	-- Auto-create Settings tab
	local SettingsTab = uiFunctions:CreateTab("Settings")
	
	-- UI Theme Settings
	SettingsTab:CreateLabel("UI Theme", currentSettings.MainColor)
	
	SettingsTab:CreateSideDropButton("Main Color", {"Green", "Blue", "Red", "Yellow", "Purple", "Cyan", "White"}, function(color)
		local colorMap = {
			Green = Color3.fromRGB(0, 255, 0),
			Blue = Color3.fromRGB(0, 100, 255),
			Red = Color3.fromRGB(255, 0, 0),
			Yellow = Color3.fromRGB(255, 255, 0),
			Purple = Color3.fromRGB(180, 0, 255),
			Cyan = Color3.fromRGB(0, 255, 255),
			White = Color3.fromRGB(255, 255, 255)
		}
		currentSettings.MainColor = colorMap[color] or defaultSettings.MainColor
		applySettings()
		print("Main color changed to:", color)
	end)
	
	SettingsTab:CreateSideDropButton("Background", {"50% Transparent", "25% Transparent", "75% Transparent", "Solid"}, function(transparency)
		local transparencyMap = {
			["50% Transparent"] = 0.5,
			["25% Transparent"] = 0.25,
			["75% Transparent"] = 0.75,
			["Solid"] = 0
		}
		currentSettings.BackgroundTransparency = transparencyMap[transparency] or defaultSettings.BackgroundTransparency
		applySettings()
		print("Background transparency:", transparency)
	end)
	
	SettingsTab:CreateSideDropButton("Text Color", {"White", "Black", "Light Gray"}, function(textColor)
		local colorMap = {
			White = Color3.fromRGB(255, 255, 255),
			Black = Color3.fromRGB(0, 0, 0),
			["Light Gray"] = Color3.fromRGB(200, 200, 200)
		}
		currentSettings.TextColor = colorMap[textColor] or defaultSettings.TextColor
		applySettings()
		print("Text color changed to:", textColor)
	end)
	
	SettingsTab:CreateSideDropButton("Font", {"JosefinSans", "SourceSans", "Gotham", "Code"}, function(font)
		local fontMap = {
			JosefinSans = Enum.Font.JosefinSans,
			SourceSans = Enum.Font.SourceSans,
			Gotham = Enum.Font.Gotham,
			Code = Enum.Font.Code
		}
		currentSettings.Font = fontMap[font] or defaultSettings.Font
		applySettings()
		print("Font changed to:", font)
	end)
	
	SettingsTab:CreateLabel("UI Controls", currentSettings.MainColor)
	
	SettingsTab:CreateButton("Reset to Default", "Resets all UI settings", function()
		currentSettings = tableClone(defaultSettings)
		applySettings()
		print("UI settings reset to default!")
	end)
	
	SettingsTab:CreateButton("Destroy UI", "Permanently removes the UI", function()
		Rodus:Destroy()
		print("UI completely destroyed!")
	end)
	
	SettingsTab:CreateLabel("RightControl: Hide/Show", currentSettings.TextColor)
	SettingsTab:CreateLabel("Minimize: Collapse/Expand", currentSettings.TextColor)

	return uiFunctions
end

-- Create global functions for executor compatibility
_G.CreateMain = function(title)
	return Rodus:CreateMain(title)
end

return Rodus
