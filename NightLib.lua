-- Rodus UI Library - Executor Ready
local Rodus = {}

-- Default theme settings
local defaultSettings = {
	MainColor = Color3.fromRGB(0, 255, 0),
	BackgroundTransparency = 0.5,
	TextColor = Color3.fromRGB(255, 255, 255),
	Font = Enum.Font.JosefinSans,
	TextSize = 14,
	AnimationSpeed = 0.3
}

-- Safe wait function for executors
local function safeWait(duration)
	if duration and duration > 0 then
		local endTime = os.clock() + duration
		while os.clock() < endTime do end
	end
end

-- Safe instance creation
local function createInstance(className, properties)
	local instance = Instance.new(className)
	for property, value in pairs(properties or {}) do
		pcall(function()
			instance[property] = value
		end)
	end
	return instance
end

function Rodus:CreateMain(title)
	-- Get CoreGui safely for executors
	local coreGui = game:GetService("CoreGui")
	local player = game.Players.LocalPlayer
	local parent = coreGui -- Use CoreGui for executors
	
	-- Destroy existing UI with same name
	local destroyIfExist = parent:GetChildren()
	for _, gui in pairs(destroyIfExist) do
		if gui.Name == title then
			print("Destroyed "..tostring(title)..": Already existed")
			gui:Destroy()
		end
	end

	-- Current settings (start with defaults)
	local currentSettings = {}
	for k, v in pairs(defaultSettings) do
		currentSettings[k] = v
	end
	
	-- Main UI Instances
	local Rodus = createInstance("ScreenGui", {
		Name = tostring(title),
		Parent = parent,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	})

	local Top = createInstance("Frame", {
		Name = "Top",
		Parent = Rodus,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = currentSettings.BackgroundTransparency,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 4,
		Position = UDim2.new(0, 15, 0, 15),
		Size = UDim2.new(0, 193, 0, 27)
	})

	local Title = createInstance("TextLabel", {
		Name = "Title",
		Parent = Top,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 0.350,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 193, 0, 27),
		Font = currentSettings.Font,
		Text = " "..title,
		TextColor3 = currentSettings.MainColor,
		TextSize = currentSettings.TextSize,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	local Container = createInstance("Frame", {
		Name = "Container",
		Parent = Top,
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = currentSettings.BackgroundTransparency,
		BorderColor3 = Color3.fromRGB(0, 0, 0),
		BorderSizePixel = 4,
		Position = UDim2.new(0, 0, 1.29629624, 0),
		Size = UDim2.new(0, 193, 0, 24)
	})

	local UIListLayout = createInstance("UIListLayout", {
		Parent = Container,
		SortOrder = Enum.SortOrder.LayoutOrder
	})

	local Minimize = createInstance("TextButton", {
		Name = "Minimize",
		Parent = Top,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1.000,
		Position = UDim2.new(0.906735778, 0, 0.185185179, 0),
		Size = UDim2.new(0, 18, 0, 17),
		Font = Enum.Font.SourceSans,
		Text = "-",
		TextColor3 = currentSettings.TextColor,
		TextSize = 14.000
	})

	-- Track created tabs to ensure Settings is last
	local createdTabs = {}
	local settingsTabCreated = false

	-- Apply settings function
	local function applySettings()
		-- Apply to main UI
		Top.BackgroundTransparency = currentSettings.BackgroundTransparency
		Title.TextColor3 = currentSettings.MainColor
		Title.Font = currentSettings.Font
		Title.TextSize = currentSettings.TextSize
		
		-- Apply to all existing elements
		local function applyToDescendants(parentObj)
			for _, child in pairs(parentObj:GetDescendants()) do
				if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
					pcall(function() child.Font = currentSettings.Font end)
					pcall(function() child.TextSize = currentSettings.TextSize end)
					
					if child:IsA("TextLabel") and child.Name == "Title" then
						pcall(function() child.TextColor3 = currentSettings.MainColor end)
					elseif child:IsA("TextButton") and child.Parent == Container then
						if child.TextColor3 == Color3.new(0, 255, 0) or child.TextColor3 == defaultSettings.MainColor then
							pcall(function() child.TextColor3 = currentSettings.MainColor end)
						else
							pcall(function() child.TextColor3 = currentSettings.TextColor end)
						end
					elseif child:IsA("TextLabel") and child.Name == "Note" then
						pcall(function() child.TextColor3 = currentSettings.MainColor end)
					else
						pcall(function() child.TextColor3 = currentSettings.TextColor end)
					end
				end
				
				if child:IsA("Frame") then
					pcall(function() child.BackgroundTransparency = currentSettings.BackgroundTransparency end)
				end
			end
		end
		
		applyToDescendants(Rodus)
	end

	-- Animation function
	local function animateContainer(visible)
		local duration = currentSettings.AnimationSpeed
		
		if visible then
			-- Opening animation
			Container.Visible = true
			Container.Size = UDim2.new(0, 193, 0, 0)
			
			local targetHeight = UIListLayout.AbsoluteContentSize.Y
			local steps = 10
			local stepTime = duration / steps
			
			for i = 1, steps do
				Container.Size = UDim2.new(0, 193, 0, (targetHeight / steps) * i)
				safeWait(stepTime)
			end
			Container.Size = UDim2.new(0, 193, 0, targetHeight)
		else
			-- Closing animation
			local startHeight = Container.Size.Y.Offset
			local steps = 10
			local stepTime = duration / steps
			
			for i = steps, 1, -1 do
				Container.Size = UDim2.new(0, 193, 0, (startHeight / steps) * i)
				safeWait(stepTime)
			end
			Container.Size = UDim2.new(0, 193, 0, 0)
			Container.Visible = false
		end
	end

	-- Minimize functionality with animations
	local tog_gled = false
	Minimize.MouseButton1Down:Connect(function()
		tog_gled = not tog_gled
		if tog_gled then 
			Minimize.Text = "+"
			animateContainer(false)
		else 
			Minimize.Text = "-"
			animateContainer(true)
		end
	end)

	-- Toggle visibility with RightControl
	local function onKeyPress(inputObject, gameProcessedEvent)
		if not gameProcessedEvent and inputObject.KeyCode == Enum.KeyCode.RightControl then
			Top.Visible = not Top.Visible
		end
	end
	game:GetService("UserInputService").InputBegan:Connect(onKeyPress)

	-- UI Functions
	local uiFunctions = {}

	function uiFunctions:CreateTab(text)
		-- Don't allow creating Settings tab manually
		if string.lower(text) == "settings" then
			error("Settings tab is automatically created as the last tab")
			return
		end
		
		local Tab = createInstance("TextButton", {
			Name = text,
			Parent = Container,
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1.000,
			Size = UDim2.new(0, 193, 0, 24),
			Font = currentSettings.Font,
			Text = " "..text,
			TextColor3 = currentSettings.TextColor,
			TextSize = currentSettings.TextSize,
			TextXAlignment = Enum.TextXAlignment.Left
		})

		local Arrow = createInstance("TextLabel", {
			Name = "Arrow",
			Parent = Tab,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0.907, 0, 0, 0),
			Size = UDim2.new(0, 18, 0, 21),
			Font = Enum.Font.SourceSans,
			Text = ">>",
			TextColor3 = currentSettings.TextColor,
			TextScaled = true,
			TextSize = 14.000,
			TextWrapped = true
		})
		
		-- Update container size
		Container.Size = UDim2.new(0, 193, 0, UIListLayout.AbsoluteContentSize.Y)
		
		-- Tab Container
		local TabContainer = createInstance("Frame", {
			Name = "TabContainer",
			Parent = Tab,
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = currentSettings.BackgroundTransparency,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 4,
			Position = UDim2.new(1.0569948, 0, 0, 0),
			Visible = false
		})
		
		local UIListLayout2 = createInstance("UIListLayout", {
			Parent = TabContainer,
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		-- Tab click functionality with animation
		Tab.MouseButton1Down:Connect(function()
			local isCurrentlyOpen = TabContainer.Visible
			local duration = currentSettings.AnimationSpeed
			
			-- Close ALL tab containers and reset ALL colors first
			local allTabs = Container:GetDescendants()
			for _, element in pairs(allTabs) do
				if element.Name == "TabContainer" and element.Visible then
					-- Animate closing
					local startHeight = element.Size.Y.Offset
					local steps = 8
					local stepTime = duration / steps
					
					for i = steps, 1, -1 do
						element.Size = UDim2.new(0, 193, 0, (startHeight / steps) * i)
						safeWait(stepTime)
					end
					element.Visible = false
					element.Size = UDim2.new(0, 193, 0, 0)
				end
				
				if element:IsA("TextButton") and element.Parent == Container then
					element.TextColor3 = currentSettings.TextColor
					if element:FindFirstChild("Arrow") then
						element.Arrow.TextColor3 = currentSettings.TextColor
					end
				end
			end
			
			-- If this tab wasn't open before, open it with animation
			if not isCurrentlyOpen then
				TabContainer.Visible = true
				TabContainer.Size = UDim2.new(0, 193, 0, 0)
				
				safeWait(0.01) -- Small delay for layout calculation
				local targetHeight = UIListLayout2.AbsoluteContentSize.Y
				local steps = 10
				local stepTime = duration / steps
				
				for i = 1, steps do
					TabContainer.Size = UDim2.new(0, 193, 0, (targetHeight / steps) * i)
					safeWait(stepTime)
				end
				TabContainer.Size = UDim2.new(0, 193, 0, targetHeight)
				
				Tab.TextColor3 = currentSettings.MainColor
				if Tab:FindFirstChild("Arrow") then
					Tab.Arrow.TextColor3 = currentSettings.MainColor
				end
			end
		end)

		-- Tab-specific functions
		local tabFunctions = {}

		function tabFunctions:CreateButton(buttonText, note, callback)
			local Button = createInstance("TextButton", {
				Name = buttonText,
				Parent = TabContainer,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1.000,
				Size = UDim2.new(0, 193, 0, 24),
				Font = currentSettings.Font,
				Text = " "..buttonText,
				TextColor3 = currentSettings.TextColor,
				TextSize = currentSettings.TextSize,
				TextXAlignment = Enum.TextXAlignment.Left
			})

			local Note = createInstance("TextLabel", {
				Name = "Note",
				Parent = Button,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				Position = UDim2.new(1.04145074, 0, 0, 0),
				Size = UDim2.new(0, 193, 0, 24),
				Font = currentSettings.Font,
				Text = note or "",
				TextColor3 = currentSettings.MainColor,
				TextSize = currentSettings.TextSize,
				TextXAlignment = Enum.TextXAlignment.Left,
				Visible = false
			})
			
			Button.MouseButton1Down:Connect(function()
				Button.TextColor3 = currentSettings.MainColor
				safeWait(0.05)
				Button.TextColor3 = currentSettings.TextColor
				if callback then
					pcall(callback)
				end
			end)

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
			local Label = createInstance("TextLabel", {
				Name = labelText,
				Parent = TabContainer,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1.000,
				Size = UDim2.new(0, 193, 0, 24),
				Font = currentSettings.Font,
				Text = " "..labelText,
				TextColor3 = color3 or currentSettings.TextColor,
				TextSize = currentSettings.TextSize,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			TabContainer.Size = UDim2.new(0, 193, 0, UIListLayout2.AbsoluteContentSize.Y)
		end

		function tabFunctions:CreateToggle(buttonText, note, callback)
			local Button = createInstance("TextButton", {
				Name = buttonText,
				Parent = TabContainer,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1.000,
				Size = UDim2.new(0, 193, 0, 24),
				Font = currentSettings.Font,
				Text = " "..buttonText,
				TextColor3 = currentSettings.TextColor,
				TextSize = currentSettings.TextSize,
				TextXAlignment = Enum.TextXAlignment.Left
			})

			local Toggle = createInstance("BoolValue", {
				Parent = Button,
				Name = "Toggled",
				Value = false
			})

			local Note = createInstance("TextLabel", {
				Name = "Note",
				Parent = Button,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				Position = UDim2.new(1.04145074, 0, 0, 0),
				Size = UDim2.new(0, 193, 0, 24),
				Font = currentSettings.Font,
				Text = note or "",
				TextColor3 = currentSettings.MainColor,
				TextSize = currentSettings.TextSize,
				TextXAlignment = Enum.TextXAlignment.Left,
				Visible = false
			})

			Button.MouseEnter:Connect(function()
				Note.Visible = true
			end)

			Button.MouseLeave:Connect(function()
				Note.Visible = false
			end)

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
			
			TabContainer.Size = UDim2.new(0, 193, 0, UIListLayout2.AbsoluteContentSize.Y)
			
			return Toggle
		end

		function tabFunctions:CreateSideDropButton(dropText, list, callback)
			local SideDrop = createInstance("TextButton", {
				Name = dropText,
				Parent = TabContainer,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1.000,
				Size = UDim2.new(0, 193, 0, 24),
				Font = currentSettings.Font,
				Text = " "..dropText,
				TextColor3 = currentSettings.TextColor,
				TextSize = currentSettings.TextSize,
				TextXAlignment = Enum.TextXAlignment.Left
			})

			local Arrow = createInstance("TextButton", {
				Name = "Arrow",
				Parent = SideDrop,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				Position = UDim2.new(0.906735778, 0, 0, 0),
				Size = UDim2.new(0, 18, 0, 21),
				Font = Enum.Font.SourceSans,
				Text = ">>",
				TextColor3 = currentSettings.TextColor,
				TextScaled = true,
				TextSize = 14.000,
				TextWrapped = true
			})

			local DropContainer = createInstance("Frame", {
				Name = "DropContainer",
				Parent = SideDrop,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = currentSettings.BackgroundTransparency,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 4,
				Position = UDim2.new(1.08290148, 0, 0, 0),
				Size = UDim2.new(0, 193, 0, 0),
				Visible = false
			})

			local DropUIListLayout = createInstance("UIListLayout", {
				Parent = DropContainer,
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			-- Dropdown toggle with animation
			SideDrop.MouseButton1Down:Connect(function()
				local allDropContainers = TabContainer:GetDescendants()
				local duration = currentSettings.AnimationSpeed
				
				-- Close other dropdowns with animation
				for _, element in pairs(allDropContainers) do
					if element.Name == "DropContainer" and element ~= DropContainer and element.Visible then
						local startHeight = element.Size.Y.Offset
						local steps = 6
						local stepTime = duration / steps
						
						for i = steps, 1, -1 do
							element.Size = UDim2.new(0, 193, 0, (startHeight / steps) * i)
							safeWait(stepTime)
						end
						element.Visible = false
						element.Size = UDim2.new(0, 193, 0, 0)
						
						if element.Parent:FindFirstChild("TextColor3") then
							element.Parent.TextColor3 = currentSettings.TextColor
						end
						if element.Parent:FindFirstChild("Arrow") then
							element.Parent.Arrow.TextColor3 = currentSettings.TextColor
						end
					end
				end

				-- Toggle current dropdown with animation
				if not DropContainer.Visible then
					DropContainer.Visible = true
					DropContainer.Size = UDim2.new(0, 193, 0, 0)
					
					safeWait(0.01)
					local targetHeight = DropUIListLayout.AbsoluteContentSize.Y
					local steps = 8
					local stepTime = duration / steps
					
					for i = 1, steps do
						DropContainer.Size = UDim2.new(0, 193, 0, (targetHeight / steps) * i)
						safeWait(stepTime)
					end
					DropContainer.Size = UDim2.new(0, 193, 0, targetHeight)
					
					SideDrop.TextColor3 = currentSettings.MainColor
					Arrow.TextColor3 = currentSettings.MainColor
				else
					-- Animate closing
					local startHeight = DropContainer.Size.Y.Offset
					local steps = 6
					local stepTime = duration / steps
					
					for i = steps, 1, -1 do
						DropContainer.Size = UDim2.new(0, 193, 0, (startHeight / steps) * i)
						safeWait(stepTime)
					end
					DropContainer.Visible = false
					DropContainer.Size = UDim2.new(0, 193, 0, 0)
					
					SideDrop.TextColor3 = currentSettings.TextColor
					Arrow.TextColor3 = currentSettings.TextColor
				end
			end)

			-- Create dropdown items
			for _, option in pairs(list or {}) do
				local Button = createInstance("TextButton", {
					Name = option,
					Parent = DropContainer,
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1.000,
					Size = UDim2.new(0, 193, 0, 24),
					Font = currentSettings.Font,
					Text = " "..option,
					TextColor3 = currentSettings.TextColor,
					TextSize = currentSettings.TextSize,
					TextXAlignment = Enum.TextXAlignment.Left
				})

				Button.MouseButton1Down:Connect(function()
					Button.TextColor3 = currentSettings.MainColor
					safeWait(0.05)
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
			local TextBoxBtn = createInstance("TextButton", {
				Name = buttonText,
				Parent = TabContainer,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1.000,
				Size = UDim2.new(0, 193, 0, 24),
				Font = currentSettings.Font,
				Text = " "..buttonText,
				TextColor3 = currentSettings.TextColor,
				TextSize = currentSettings.TextSize,
				TextXAlignment = Enum.TextXAlignment.Left
			})

			local Arrow = createInstance("TextButton", {
				Name = "Arrow",
				Parent = TextBoxBtn,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				Position = UDim2.new(0.906735778, 0, 0, 0),
				Size = UDim2.new(0, 18, 0, 21),
				Font = Enum.Font.SourceSans,
				Text = ">>",
				TextColor3 = currentSettings.TextColor,
				TextScaled = true,
				TextSize = 14.000,
				TextWrapped = true
			})

			local Side = createInstance("Frame", {
				Name = "Side",
				Parent = TextBoxBtn,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = currentSettings.BackgroundTransparency,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 4,
				Position = UDim2.new(1.08290148, 0, 0, 0),
				Size = UDim2.new(0, 193, 0, 24),
				Visible = false
			})

			local Box = createInstance("TextBox", {
				Name = "Box",
				Parent = Side,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				Size = UDim2.new(0, 193, 0, 24),
				Font = currentSettings.Font,
				Text = "",
				TextColor3 = currentSettings.TextColor,
				TextSize = currentSettings.TextSize,
				TextWrapped = true,
				PlaceholderText = placeholderText or "Enter text..."
			})

			local Hover = createInstance("Frame", {
				Name = "Hover",
				Parent = TextBoxBtn,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				Size = UDim2.new(0, 209, 0, 32)
			})

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
				safeWait(0.05)
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

		-- Store the tab
		table.insert(createdTabs, {tab = Tab, functions = tabFunctions})
		
		return tabFunctions
	end

	-- Function to create Settings tab (always last)
	local function createSettingsTab()
		if settingsTabCreated then return end
		
		-- Create Settings tab manually to ensure it's last
		local SettingsTab = createInstance("TextButton", {
			Name = "Settings",
			Parent = Container,
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1.000,
			Size = UDim2.new(0, 193, 0, 24),
			Font = currentSettings.Font,
			Text = " Settings",
			TextColor3 = currentSettings.TextColor,
			TextSize = currentSettings.TextSize,
			TextXAlignment = Enum.TextXAlignment.Left
		})

		local Arrow = createInstance("TextLabel", {
			Name = "Arrow",
			Parent = SettingsTab,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 1.000,
			Position = UDim2.new(0.907, 0, 0, 0),
			Size = UDim2.new(0, 18, 0, 21),
			Font = Enum.Font.SourceSans,
			Text = ">>",
			TextColor3 = currentSettings.TextColor,
			TextScaled = true,
			TextSize = 14.000,
			TextWrapped = true
		})
		
		local TabContainer = createInstance("Frame", {
			Name = "TabContainer",
			Parent = SettingsTab,
			BackgroundColor3 = Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = currentSettings.BackgroundTransparency,
			BorderColor3 = Color3.fromRGB(0, 0, 0),
			BorderSizePixel = 4,
			Position = UDim2.new(1.0569948, 0, 0, 0),
			Visible = false
		})
		
		local UIListLayout2 = createInstance("UIListLayout", {
			Parent = TabContainer,
			SortOrder = Enum.SortOrder.LayoutOrder
		})

		-- Tab click functionality
		SettingsTab.MouseButton1Down:Connect(function()
			local isCurrentlyOpen = TabContainer.Visible
			local duration = currentSettings.AnimationSpeed
			
			-- Close ALL tab containers and reset ALL colors first
			local allTabs = Container:GetDescendants()
			for _, element in pairs(allTabs) do
				if element.Name == "TabContainer" and element.Visible then
					local startHeight = element.Size.Y.Offset
					local steps = 8
					local stepTime = duration / steps
					
					for i = steps, 1, -1 do
						element.Size = UDim2.new(0, 193, 0, (startHeight / steps) * i)
						safeWait(stepTime)
					end
					element.Visible = false
					element.Size = UDim2.new(0, 193, 0, 0)
				end
				
				if element:IsA("TextButton") and element.Parent == Container then
					element.TextColor3 = currentSettings.TextColor
					if element:FindFirstChild("Arrow") then
						element.Arrow.TextColor3 = currentSettings.TextColor
					end
				end
			end
			
			if not isCurrentlyOpen then
				TabContainer.Visible = true
				TabContainer.Size = UDim2.new(0, 193, 0, 0)
				
				safeWait(0.01)
				local targetHeight = UIListLayout2.AbsoluteContentSize.Y
				local steps = 10
				local stepTime = duration / steps
				
				for i = 1, steps do
					TabContainer.Size = UDim2.new(0, 193, 0, (targetHeight / steps) * i)
					safeWait(stepTime)
				end
				TabContainer.Size = UDim2.new(0, 193, 0, targetHeight)
				
				SettingsTab.TextColor3 = currentSettings.MainColor
				Arrow.TextColor3 = currentSettings.MainColor
			end
		end)

		-- Settings tab content
		-- UI Theme Settings
		local function createSettingsLabel(text, color)
			local label = createInstance("TextLabel", {
				Name = text,
				Parent = TabContainer,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1.000,
				Size = UDim2.new(0, 193, 0, 24),
				Font = currentSettings.Font,
				Text = " "..text,
				TextColor3 = color or currentSettings.TextColor,
				TextSize = currentSettings.TextSize,
				TextXAlignment = Enum.TextXAlignment.Left
			})
		end

		local function createSettingsButton(buttonText, note, callback)
			local button = createInstance("TextButton", {
				Name = buttonText,
				Parent = TabContainer,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1.000,
				Size = UDim2.new(0, 193, 0, 24),
				Font = currentSettings.Font,
				Text = " "..buttonText,
				TextColor3 = currentSettings.TextColor,
				TextSize = currentSettings.TextSize,
				TextXAlignment = Enum.TextXAlignment.Left
			})

			local noteLabel = createInstance("TextLabel", {
				Name = "Note",
				Parent = button,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				Position = UDim2.new(1.04145074, 0, 0, 0),
				Size = UDim2.new(0, 193, 0, 24),
				Font = currentSettings.Font,
				Text = note or "",
				TextColor3 = currentSettings.MainColor,
				TextSize = currentSettings.TextSize,
				TextXAlignment = Enum.TextXAlignment.Left,
				Visible = false
			})
			
			button.MouseButton1Down:Connect(function()
				button.TextColor3 = currentSettings.MainColor
				safeWait(0.05)
				button.TextColor3 = currentSettings.TextColor
				if callback then
					pcall(callback)
				end
			end)

			button.MouseEnter:Connect(function()
				noteLabel.Visible = true
			end)

			button.MouseLeave:Connect(function()
				noteLabel.Visible = false
			end)
		end

		local function createSettingsDropdown(dropText, list, callback)
			local sideDrop = createInstance("TextButton", {
				Name = dropText,
				Parent = TabContainer,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = 1.000,
				Size = UDim2.new(0, 193, 0, 24),
				Font = currentSettings.Font,
				Text = " "..dropText,
				TextColor3 = currentSettings.TextColor,
				TextSize = currentSettings.TextSize,
				TextXAlignment = Enum.TextXAlignment.Left
			})

			local dropArrow = createInstance("TextButton", {
				Name = "Arrow",
				Parent = sideDrop,
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1.000,
				Position = UDim2.new(0.906735778, 0, 0, 0),
				Size = UDim2.new(0, 18, 0, 21),
				Font = Enum.Font.SourceSans,
				Text = ">>",
				TextColor3 = currentSettings.TextColor,
				TextScaled = true,
				TextSize = 14.000,
				TextWrapped = true
			})

			local dropContainer = createInstance("Frame", {
				Name = "DropContainer",
				Parent = sideDrop,
				BackgroundColor3 = Color3.fromRGB(0, 0, 0),
				BackgroundTransparency = currentSettings.BackgroundTransparency,
				BorderColor3 = Color3.fromRGB(0, 0, 0),
				BorderSizePixel = 4,
				Position = UDim2.new(1.08290148, 0, 0, 0),
				Size = UDim2.new(0, 193, 0, 0),
				Visible = false
			})

			local dropUIListLayout = createInstance("UIListLayout", {
				Parent = dropContainer,
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			-- Dropdown toggle
			sideDrop.MouseButton1Down:Connect(function()
				local allDropContainers = TabContainer:GetDescendants()
				local duration = currentSettings.AnimationSpeed
				
				for _, element in pairs(allDropContainers) do
					if element.Name == "DropContainer" and element ~= dropContainer and element.Visible then
						local startHeight = element.Size.Y.Offset
						local steps = 6
						local stepTime = duration / steps
						
						for i = steps, 1, -1 do
							element.Size = UDim2.new(0, 193, 0, (startHeight / steps) * i)
							safeWait(stepTime)
						end
						element.Visible = false
						element.Size = UDim2.new(0, 193, 0, 0)
						
						if element.Parent:FindFirstChild("TextColor3") then
							element.Parent.TextColor3 = currentSettings.TextColor
						end
						if element.Parent:FindFirstChild("Arrow") then
							element.Parent.Arrow.TextColor3 = currentSettings.TextColor
						end
					end
				end

				if not dropContainer.Visible then
					dropContainer.Visible = true
					dropContainer.Size = UDim2.new(0, 193, 0, 0)
					
					safeWait(0.01)
					local targetHeight = dropUIListLayout.AbsoluteContentSize.Y
					local steps = 8
					local stepTime = duration / steps
					
					for i = 1, steps do
						dropContainer.Size = UDim2.new(0, 193, 0, (targetHeight / steps) * i)
						safeWait(stepTime)
					end
					dropContainer.Size = UDim2.new(0, 193, 0, targetHeight)
					
					sideDrop.TextColor3 = currentSettings.MainColor
					dropArrow.TextColor3 = currentSettings.MainColor
				else
					local startHeight = dropContainer.Size.Y.Offset
					local steps = 6
					local stepTime = duration / steps
					
					for i = steps, 1, -1 do
						dropContainer.Size = UDim2.new(0, 193, 0, (startHeight / steps) * i)
						safeWait(stepTime)
					end
					dropContainer.Visible = false
					dropContainer.Size = UDim2.new(0, 193, 0, 0)
					
					sideDrop.TextColor3 = currentSettings.TextColor
					dropArrow.TextColor3 = currentSettings.TextColor
				end
			end)

			for _, option in pairs(list or {}) do
				local button = createInstance("TextButton", {
					Name = option,
					Parent = dropContainer,
					BackgroundColor3 = Color3.fromRGB(0, 0, 0),
					BackgroundTransparency = 1.000,
					Size = UDim2.new(0, 193, 0, 24),
					Font = currentSettings.Font,
					Text = " "..option,
					TextColor3 = currentSettings.TextColor,
					TextSize = currentSettings.TextSize,
					TextXAlignment = Enum.TextXAlignment.Left
				})

				button.MouseButton1Down:Connect(function()
					button.TextColor3 = currentSettings.MainColor
					safeWait(0.05)
					button.TextColor3 = currentSettings.TextColor
					if callback then
						pcall(callback, option)
					end
				end)
			end

			dropContainer.Size = UDim2.new(0, 193, 0, dropUIListLayout.AbsoluteContentSize.Y)
		end

		-- Add settings content
		createSettingsLabel("UI Theme", currentSettings.MainColor)
		
		createSettingsDropdown("Main Color", {"Green", "Blue", "Red", "Yellow", "Purple", "Cyan", "White"}, function(color)
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
		end)
		
		createSettingsDropdown("Background", {"50% Transparent", "25% Transparent", "75% Transparent", "Solid"}, function(transparency)
			local transparencyMap = {
				["50% Transparent"] = 0.5,
				["25% Transparent"] = 0.25,
				["75% Transparent"] = 0.75,
				["Solid"] = 0
			}
			currentSettings.BackgroundTransparency = transparencyMap[transparency] or defaultSettings.BackgroundTransparency
			applySettings()
		end)
		
		createSettingsDropdown("Text Color", {"White", "Black", "Light Gray"}, function(textColor)
			local colorMap = {
				White = Color3.fromRGB(255, 255, 255),
				Black = Color3.fromRGB(0, 0, 0),
				["Light Gray"] = Color3.fromRGB(200, 200, 200)
			}
			currentSettings.TextColor = colorMap[textColor] or defaultSettings.TextColor
			applySettings()
		end)
		
		createSettingsDropdown("Font", {"JosefinSans", "SourceSans", "Gotham", "Code"}, function(font)
			local fontMap = {
				JosefinSans = Enum.Font.JosefinSans,
				SourceSans = Enum.Font.SourceSans,
				Gotham = Enum.Font.Gotham,
				Code = Enum.Font.Code
			}
			currentSettings.Font = fontMap[font] or defaultSettings.Font
			applySettings()
		end)
		
		createSettingsDropdown("Animation Speed", {"Fast", "Medium", "Slow", "Instant"}, function(speed)
			local speedMap = {
				Fast = 0.15,
				Medium = 0.3,
				Slow = 0.5,
				Instant = 0
			}
			currentSettings.AnimationSpeed = speedMap[speed] or defaultSettings.AnimationSpeed
		end)
		
		createSettingsLabel("UI Controls", currentSettings.MainColor)
		
		createSettingsButton("Reset to Default", "Resets all UI settings", function()
			for k, v in pairs(defaultSettings) do
				currentSettings[k] = v
			end
			applySettings()
		end)
		
		createSettingsButton("Destroy UI", "Permanently removes the UI", function()
			Rodus:Destroy()
		end)
		
		createSettingsLabel("RightControl: Hide/Show", currentSettings.TextColor)
		createSettingsLabel("Minimize: Collapse/Expand", currentSettings.TextColor)

		TabContainer.Size = UDim2.new(0, 193, 0, UIListLayout2.AbsoluteContentSize.Y)
		settingsTabCreated = true
	end

	-- Create Settings tab after a short delay to ensure it's last
	spawn(function()
		safeWait(0.1)
		createSettingsTab()
		Container.Size = UDim2.new(0, 193, 0, UIListLayout.AbsoluteContentSize.Y)
	end)

	return uiFunctions
end

return Rodus
