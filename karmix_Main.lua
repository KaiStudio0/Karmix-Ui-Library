--[[
    Karmix Library v1.0
    Modern Ui Library
    Autor: Kai's Team
]]

local Karmix = {}
Karmix.__index = Karmix

-- Servicios
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

-- Variables locales
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Configuración por defecto
local Config = {
    AnimationSpeed = 0.3,
    DefaultSize = UDim2.new(0, 500, 0, 400),
    DefaultPosition = UDim2.new(0.5, -250, 0.5, -200),
    CornerRadius = 8,
    Padding = 8
}

-- Temas
local Themes = {
    Dark = {
        Background = Color3.new(0.1, 0.1, 0.1),
        Surface = Color3.new(0.15, 0.15, 0.15),
        Primary = Color3.new(0.2, 0.4, 1),
        Secondary = Color3.new(0.3, 0.3, 0.35),
        Text = Color3.new(1, 1, 1),
        TextSecondary = Color3.new(0.7, 0.7, 0.7),
        Success = Color3.new(0.2, 0.8, 0.2),
        Warning = Color3.new(1, 0.6, 0),
        Error = Color3.new(1, 0.2, 0.2),
        Border = Color3.new(0.25, 0.25, 0.25)
    },
    Light = {
        Background = Color3.new(1, 1, 1),
        Surface = Color3.new(0.95, 0.95, 0.95),
        Primary = Color3.new(0.2, 0.4, 1),
        Secondary = Color3.new(0.8, 0.8, 0.8),
        Text = Color3.new(0, 0, 0),
        TextSecondary = Color3.new(0.4, 0.4, 0.4),
        Success = Color3.new(0.2, 0.8, 0.2),
        Warning = Color3.new(1, 0.6, 0),
        Error = Color3.new(1, 0.2, 0.2),
        Border = Color3.new(0.7, 0.7, 0.7)
    }
}

-- Utilidades
local Utils = {}

function Utils.CreateCorner(radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or Config.CornerRadius)
    return corner
end

function Utils.CreatePadding(padding)
    local pad = Instance.new("UIPadding")
    local p = padding or Config.Padding
    pad.PaddingTop = UDim.new(0, p)
    pad.PaddingBottom = UDim.new(0, p)
    pad.PaddingLeft = UDim.new(0, p)
    pad.PaddingRight = UDim.new(0, p)
    return pad
end

function Utils.CreateStroke(color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    return stroke
end

function Utils.Tween(object, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or Config.AnimationSpeed,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Constructor principal
function Karmix.new(title, theme)
    local self = setmetatable({}, Karmix)
    
    self.Title = title or "Karmix Library"
    self.Theme = Themes[theme] or Themes.Dark
    self.Components = {}
    self.Notifications = {}
    
    self:CreateGui()
    self:SetupDragging()
    
    return self
end

-- Crear la GUI principal
function Karmix:CreateGui()
    -- ScreenGui principal
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "KarmixLibrary"
    self.ScreenGui.Parent = PlayerGui
    self.ScreenGui.ResetOnSpawn = false
    
    -- Contenedor principal
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = Config.DefaultSize
    self.MainFrame.Position = Config.DefaultPosition
    self.MainFrame.BackgroundColor3 = self.Theme.Background
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    
    Utils.CreateCorner(Config.CornerRadius).Parent = self.MainFrame
    Utils.CreateStroke(self.Theme.Border, 1).Parent = self.MainFrame
    
    -- Barra de título
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    self.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    self.TitleBar.BackgroundColor3 = self.Theme.Primary
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.MainFrame
    
    Utils.CreateCorner(Config.CornerRadius).Parent = self.TitleBar
    
    -- Clip para la barra de título
    local titleClip = Instance.new("Frame")
    titleClip.Size = UDim2.new(1, 0, 0.5, 0)
    titleClip.Position = UDim2.new(0, 0, 0.5, 0)
    titleClip.BackgroundColor3 = self.Theme.Primary
    titleClip.BorderSizePixel = 0
    titleClip.Parent = self.TitleBar
    
    -- Título
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "TitleLabel"
    self.TitleLabel.Size = UDim2.new(1, -50, 1, 0)
    self.TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = self.Title
    self.TitleLabel.TextColor3 = Color3.new(1, 1, 1)
    self.TitleLabel.TextScaled = false
    self.TitleLabel.TextSize = 16
    self.TitleLabel.Font = Enum.Font.SourceSansBold
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = self.TitleBar
    
    -- Botón de cerrar
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Size = UDim2.new(0, 30, 0, 30)
    self.CloseButton.Position = UDim2.new(1, -35, 0, 5)
    self.CloseButton.BackgroundColor3 = Color3.new(1, 0.3, 0.3)
    self.CloseButton.BorderSizePixel = 0
    self.CloseButton.Text = "×"
    self.CloseButton.TextColor3 = Color3.new(1, 1, 1)
    self.CloseButton.TextSize = 18
    self.CloseButton.Font = Enum.Font.SourceSansBold
    self.CloseButton.Parent = self.TitleBar
    
    Utils.CreateCorner(15).Parent = self.CloseButton
    
    -- Contenedor de contenido
    self.ContentFrame = Instance.new("ScrollingFrame")
    self.ContentFrame.Name = "ContentFrame"
    self.ContentFrame.Size = UDim2.new(1, 0, 1, -50)
    self.ContentFrame.Position = UDim2.new(0, 0, 0, 50)
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.ScrollBarThickness = 6
    self.ContentFrame.ScrollBarImageColor3 = self.Theme.Primary
    self.ContentFrame.Parent = self.MainFrame
    
    -- Layout para el contenido
    self.ContentLayout = Instance.new("UIListLayout")
    self.ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.ContentLayout.Padding = UDim.new(0, 5)
    self.ContentLayout.Parent = self.ContentFrame
    
    Utils.CreatePadding(10).Parent = self.ContentFrame
    
    -- Eventos
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Hide()
    end)
    
    -- Animación de entrada
    self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    Utils.Tween(self.MainFrame, {Size = Config.DefaultSize}, 0.5, Enum.EasingStyle.Back)
end

-- Sistema de arrastrar
function Karmix:SetupDragging()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    
    self.TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Método para crear botones
function Karmix:CreateButton(text, callback)
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = self.Theme.Surface
    button.BorderSizePixel = 0
    button.Text = text or "Button"
    button.TextColor3 = self.Theme.Text
    button.TextSize = 14
    button.Font = Enum.Font.SourceSans
    button.Parent = self.ContentFrame
    
    Utils.CreateCorner().Parent = button
    Utils.CreateStroke(self.Theme.Border).Parent = button
    
    -- Efectos hover
    button.MouseEnter:Connect(function()
        Utils.Tween(button, {BackgroundColor3 = self.Theme.Primary}, 0.2)
        Utils.Tween(button, {TextColor3 = Color3.new(1, 1, 1)}, 0.2)
    end)
    
    button.MouseLeave:Connect(function()
        Utils.Tween(button, {BackgroundColor3 = self.Theme.Surface}, 0.2)
        Utils.Tween(button, {TextColor3 = self.Theme.Text}, 0.2)
    end)
    
    button.MouseButton1Click:Connect(function()
        Utils.Tween(button, {Size = UDim2.new(1, -4, 0, 31)}, 0.1)
        wait(0.1)
        Utils.Tween(button, {Size = UDim2.new(1, 0, 0, 35)}, 0.1)
        
        if callback then
            callback()
        end
    end)
    
    self:UpdateContentSize()
    return button
end

-- Método para crear sliders
function Karmix:CreateSlider(text, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Name = "SliderContainer"
    container.Size = UDim2.new(1, 0, 0, 60)
    container.BackgroundColor3 = self.Theme.Surface
    container.BorderSizePixel = 0
    container.Parent = self.ContentFrame
    
    Utils.CreateCorner().Parent = container
    Utils.CreateStroke(self.Theme.Border).Parent = container
    Utils.CreatePadding().Parent = container
    
    -- Label del slider
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. (default or min)
    label.TextColor3 = self.Theme.Text
    label.TextSize = 14
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    -- Fondo del slider
    local sliderBg = Instance.new("Frame")
    sliderBg.Name = "SliderBackground"
    sliderBg.Size = UDim2.new(1, 0, 0, 6)
    sliderBg.Position = UDim2.new(0, 0, 0, 30)
    sliderBg.BackgroundColor3 = self.Theme.Secondary
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = container
    
    Utils.CreateCorner(3).Parent = sliderBg
    
    -- Barra de progreso
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BackgroundColor3 = self.Theme.Primary
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    Utils.CreateCorner(3).Parent = sliderFill
    
    -- Botón deslizante
    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "SliderButton"
    sliderButton.Size = UDim2.new(0, 16, 0, 16)
    sliderButton.Position = UDim2.new(0, -8, 0.5, -8)
    sliderButton.BackgroundColor3 = Color3.new(1, 1, 1)
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.Parent = sliderBg
    
    Utils.CreateCorner(8).Parent = sliderButton
    Utils.CreateStroke(self.Theme.Primary, 2).Parent = sliderButton
    
    -- Lógica del slider
    local dragging = false
    local value = default or min
    
    local function updateSlider(inputPos)
        local relativePos = math.clamp((inputPos - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        value = min + (max - min) * relativePos
        
        Utils.Tween(sliderFill, {Size = UDim2.new(relativePos, 0, 1, 0)}, 0.1)
        Utils.Tween(sliderButton, {Position = UDim2.new(relativePos, -8, 0.5, -8)}, 0.1)
        
        label.Text = text .. ": " .. math.floor(value * 100) / 100
        
        if callback then
            callback(value)
        end
    end
    
    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    sliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input.Position.X)
        end
    end)
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateSlider(input.Position.X)
        end
    end)
    
    -- Inicializar posición
    local initialPos = (value - min) / (max - min)
    sliderFill.Size = UDim2.new(initialPos, 0, 1, 0)
    sliderButton.Position = UDim2.new(initialPos, -8, 0.5, -8)
    
    self:UpdateContentSize()
    return container
end

-- Método para crear toggles
function Karmix:CreateToggle(text, default, callback)
    local container = Instance.new("Frame")
    container.Name = "ToggleContainer"
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundColor3 = self.Theme.Surface
    container.BorderSizePixel = 0
    container.Parent = self.ContentFrame
    
    Utils.CreateCorner().Parent = container
    Utils.CreateStroke(self.Theme.Border).Parent = container
    Utils.CreatePadding().Parent = container
    
    -- Label del toggle
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text or "Toggle"
    label.TextColor3 = self.Theme.Text
    label.TextSize = 14
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = container
    
    -- Fondo del toggle
    local toggleBg = Instance.new("Frame")
    toggleBg.Name = "ToggleBackground"
    toggleBg.Size = UDim2.new(0, 50, 0, 24)
    toggleBg.Position = UDim2.new(1, -50, 0.5, -12)
    toggleBg.BackgroundColor3 = self.Theme.Secondary
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = container
    
    Utils.CreateCorner(12).Parent = toggleBg
    
    -- Botón del toggle
    local toggleButton = Instance.new("Frame")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 20, 0, 20)
    toggleButton.Position = UDim2.new(0, 2, 0, 2)
    toggleButton.BackgroundColor3 = Color3.new(1, 1, 1)
    toggleButton.BorderSizePixel = 0
    toggleButton.Parent = toggleBg
    
    Utils.CreateCorner(10).Parent = toggleButton
    
    -- Botón clickeable
    local clickButton = Instance.new("TextButton")
    clickButton.Size = UDim2.new(1, 0, 1, 0)
    clickButton.BackgroundTransparency = 1
    clickButton.Text = ""
    clickButton.Parent = toggleBg
    
    -- Estado del toggle
    local toggled = default or false
    
    local function updateToggle()
        if toggled then
            Utils.Tween(toggleBg, {BackgroundColor3 = self.Theme.Primary}, 0.2)
            Utils.Tween(toggleButton, {Position = UDim2.new(0, 28, 0, 2)}, 0.2)
        else
            Utils.Tween(toggleBg, {BackgroundColor3 = self.Theme.Secondary}, 0.2)
            Utils.Tween(toggleButton, {Position = UDim2.new(0, 2, 0, 2)}, 0.2)
        end
        
        if callback then
            callback(toggled)
        end
    end
    
    clickButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        updateToggle()
    end)
    
    -- Efectos hover
    clickButton.MouseEnter:Connect(function()
        Utils.Tween(toggleButton, {Size = UDim2.new(0, 22, 0, 22)}, 0.1)
        Utils.Tween(toggleButton, {Position = UDim2.new(toggled and 0 or 0, toggled and 27 or 1, 0, 1)}, 0.1)
    end)
    
    clickButton.MouseLeave:Connect(function()
        Utils.Tween(toggleButton, {Size = UDim2.new(0, 20, 0, 20)}, 0.1)
        updateToggle()
    end)
    
    -- Inicializar estado
    updateToggle()
    
    self:UpdateContentSize()
    return container
end

-- Método para crear inputs de texto
function Karmix:CreateTextBox(placeholder, callback)
    local textBox = Instance.new("TextBox")
    textBox.Name = "TextBox"
    textBox.Size = UDim2.new(1, 0, 0, 35)
    textBox.BackgroundColor3 = self.Theme.Surface
    textBox.BorderSizePixel = 0
    textBox.PlaceholderText = placeholder or "Enter text..."
    textBox.PlaceholderColor3 = self.Theme.TextSecondary
    textBox.Text = ""
    textBox.TextColor3 = self.Theme.Text
    textBox.TextSize = 14
    textBox.Font = Enum.Font.SourceSans
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.ClearTextOnFocus = false
    textBox.Parent = self.ContentFrame
    
    Utils.CreateCorner().Parent = textBox
    Utils.CreateStroke(self.Theme.Border).Parent = textBox
    Utils.CreatePadding().Parent = textBox
    
    -- Efectos de focus
    textBox.Focused:Connect(function()
        Utils.Tween(textBox, {BackgroundColor3 = self.Theme.Background}, 0.2)
        textBox.UIStroke.Color = self.Theme.Primary
    end)
    
    textBox.FocusLost:Connect(function()
        Utils.Tween(textBox, {BackgroundColor3 = self.Theme.Surface}, 0.2)
        textBox.UIStroke.Color = self.Theme.Border
        
        if callback then
            callback(textBox.Text)
        end
    end)
    
    self:UpdateContentSize()
    return textBox
end

-- Método para crear labels
function Karmix:CreateLabel(text)
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = text or "Label"
    label.TextColor3 = self.Theme.Text
    label.TextSize = 14
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = self.ContentFrame
    
    self:UpdateContentSize()
    return label
end

-- Método para crear separadores
function Karmix:CreateSeparator()
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.Size = UDim2.new(1, 0, 0, 1)
    separator.BackgroundColor3 = self.Theme.Border
    separator.BorderSizePixel = 0
    separator.Parent = self.ContentFrame
    
    self:UpdateContentSize()
    return separator
end

-- Sistema de notificaciones
function Karmix:Notify(title, message, duration, type)
    local notifContainer = Instance.new("Frame")
    notifContainer.Name = "Notification"
    notifContainer.Size = UDim2.new(0, 300, 0, 80)
    notifContainer.Position = UDim2.new(1, -320, 0, 20 + (#self.Notifications * 90))
    notifContainer.BackgroundColor3 = self.Theme.Surface
    notifContainer.BorderSizePixel = 0
    notifContainer.Parent = self.ScreenGui
    
    Utils.CreateCorner().Parent = notifContainer
    Utils.CreateStroke(self.Theme.Border, 2).Parent = notifContainer
    
    -- Barra de color según el tipo
    local colorBar = Instance.new("Frame")
    colorBar.Size = UDim2.new(0, 4, 1, 0)
    colorBar.Position = UDim2.new(0, 0, 0, 0)
    colorBar.BorderSizePixel = 0
    colorBar.Parent = notifContainer
    
    if type == "success" then
        colorBar.BackgroundColor3 = self.Theme.Success
    elseif type == "warning" then
        colorBar.BackgroundColor3 = self.Theme.Warning
    elseif type == "error" then
        colorBar.BackgroundColor3 = self.Theme.Error
    else
        colorBar.BackgroundColor3 = self.Theme.Primary
    end
    
    Utils.CreateCorner().Parent = colorBar
    
    -- Contenido de la notificación
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -14, 1, 0)
    contentFrame.Position = UDim2.new(0, 14, 0, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = notifContainer
    
    Utils.CreatePadding().Parent = contentFrame
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 20)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Notification"
    titleLabel.TextColor3 = self.Theme.Text
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = contentFrame
    
    -- Mensaje
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -20, 1, -25)
    messageLabel.Position = UDim2.new(0, 0, 0, 25)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message or ""
    messageLabel.TextColor3 = self.Theme.TextSecondary
    messageLabel.TextSize = 14
    messageLabel.Font = Enum.Font.SourceSans
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.TextWrapped = true
    messageLabel.Parent = contentFrame
    
    -- Botón de cerrar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Position = UDim2.new(1, -20, 0, 0)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "×"
    closeBtn.TextColor3 = self.Theme.TextSecondary
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.Parent = contentFrame
    
    -- Animación de entrada
    notifContainer.Position = UDim2.new(1, 0, 0, 20 + (#self.Notifications * 90))
    Utils.Tween(notifContainer, {Position = UDim2.new(1, -320, 0, 20 + (#self.Notifications * 90))}, 0.3)
    
    table.insert(self.Notifications, notifContainer)
    
    -- Auto-cerrar
    local function closeNotification()
        Utils.Tween(notifContainer, {Position = UDim2.new(1, 0, 0, notifContainer.Position.Y.Offset)}, 0.3)
        
        -- Remover de la tabla
        for i, notif in ipairs(self.Notifications) do
            if notif == notifContainer then
                table.remove(self.Notifications, i)
                break
            end
        end
        
        -- Reposicionar otras notificaciones
        for i, notif in ipairs(self.Notifications) do
            Utils.Tween(notif, {Position = UDim2.new(1, -320, 0, 20 + ((i-1) * 90))}, 0.3)
        end
        
        wait(0.3)
        notifContainer:Destroy()
    end
    
    closeBtn.MouseButton1Click:Connect(closeNotification)
    
    -- Auto-cerrar después del tiempo especificado
    spawn(function()
        wait(duration or 5)
        closeNotification()
    end)
end

-- Método para crear dropdowns
function Karmix:CreateDropdown(text, options, callback)
    local container = Instance.new("Frame")
    container.Name = "DropdownContainer"
    container.Size = UDim2.new(1, 0, 0, 35)
    container.BackgroundColor3 = self.Theme.Surface
    container.BorderSizePixel = 0
    container.Parent = self.ContentFrame
    
    Utils.CreateCorner().Parent = container
    Utils.CreateStroke(self.Theme.Border).Parent = container
    
    -- Botón principal del dropdown
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "DropdownButton"
    dropdownButton.Size = UDim2.new(1, 0, 1, 0)
    dropdownButton.BackgroundTransparency = 1
    dropdownButton.Text = text or "Select Option"
    dropdownButton.TextColor3 = self.Theme.Text
    dropdownButton.TextSize = 14
    dropdownButton.Font = Enum.Font.SourceSans
    dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
    dropdownButton.Parent = container
    
    Utils.CreatePadding().Parent = dropdownButton
    
    -- Flecha del dropdown
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -25, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = self.Theme.TextSecondary
    arrow.TextSize = 12
    arrow.Font = Enum.Font.SourceSans
    arrow.Parent = container
    
    -- Lista de opciones
    local optionsList = Instance.new("Frame")
    optionsList.Name = "OptionsList"
    optionsList.Size = UDim2.new(1, 0, 0, 0)
    optionsList.Position = UDim2.new(0, 0, 1, 2)
    optionsList.BackgroundColor3 = self.Theme.Surface
    optionsList.BorderSizePixel = 0
    optionsList.Visible = false
    optionsList.ZIndex = 10
    optionsList.Parent = container
    
    Utils.CreateCorner().Parent = optionsList
    Utils.CreateStroke(self.Theme.Border).Parent = optionsList
    
    -- Layout para las opciones
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Parent = optionsList
    
    local isOpen = false
    local selectedOption = nil
    
    -- Función para crear opciones
    local function createOption(option, index)
        local optionButton = Instance.new("TextButton")
        optionButton.Name = "Option" .. index
        optionButton.Size = UDim2.new(1, 0, 0, 30)
        optionButton.BackgroundColor3 = self.Theme.Surface
        optionButton.BorderSizePixel = 0
        optionButton.Text = option
        optionButton.TextColor3 = self.Theme.Text
        optionButton.TextSize = 14
        optionButton.Font = Enum.Font.SourceSans
        optionButton.TextXAlignment = Enum.TextXAlignment.Left
        optionButton.Parent = optionsList
        
        Utils.CreatePadding().Parent = optionButton
        
        -- Efectos hover
        optionButton.MouseEnter:Connect(function()
            Utils.Tween(optionButton, {BackgroundColor3 = self.Theme.Primary}, 0.1)
            Utils.Tween(optionButton, {TextColor3 = Color3.new(1, 1, 1)}, 0.1)
        end)
        
        optionButton.MouseLeave:Connect(function()
            Utils.Tween(optionButton, {BackgroundColor3 = self.Theme.Surface}, 0.1)
            Utils.Tween(optionButton, {TextColor3 = self.Theme.Text}, 0.1)
        end)
        
        optionButton.MouseButton1Click:Connect(function()
            selectedOption = option
            dropdownButton.Text = option
            isOpen = false
            
            Utils.Tween(optionsList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
            Utils.Tween(arrow, {Rotation = 0}, 0.2)
            
            wait(0.2)
            optionsList.Visible = false
            
            if callback then
                callback(option, index)
            end
        end)
    end
    
    -- Crear todas las opciones
    for i, option in ipairs(options or {}) do
        createOption(option, i)
    end
    
    -- Actualizar tamaño de la lista
    optionsList.Size = UDim2.new(1, 0, 0, #options * 30)
    
    -- Evento para abrir/cerrar dropdown
    dropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        
        if isOpen then
            optionsList.Visible = true
            Utils.Tween(optionsList, {Size = UDim2.new(1, 0, 0, #options * 30)}, 0.2)
            Utils.Tween(arrow, {Rotation = 180}, 0.2)
        else
            Utils.Tween(optionsList, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
            Utils.Tween(arrow, {Rotation = 0}, 0.2)
            
            wait(0.2)
            optionsList.Visible = false
        end
    end)
    
    self:UpdateContentSize()
    return container
end

-- Método para crear color pickers
function Karmix:CreateColorPicker(text, defaultColor, callback)
    local container = Instance.new("Frame")
    container.Name = "ColorPickerContainer"
    container.Size = UDim2.new(1, 0, 0, 120)
    container.BackgroundColor3 = self.Theme.Surface
    container.BorderSizePixel = 0
    container.Parent = self.ContentFrame
    
    Utils.CreateCorner().Parent = container
    Utils.CreateStroke(self.Theme.Border).Parent = container
    Utils.CreatePadding().Parent = container
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -30, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text or "Color Picker"
    label.TextColor3 = self.Theme.Text
    label.TextSize = 14
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    -- Preview del color
    local colorPreview = Instance.new("Frame")
    colorPreview.Size = UDim2.new(0, 20, 0, 20)
    colorPreview.Position = UDim2.new(1, -20, 0, 0)
    colorPreview.BackgroundColor3 = defaultColor or Color3.new(1, 1, 1)
    colorPreview.BorderSizePixel = 0
    colorPreview.Parent = container
    
    Utils.CreateCorner(4).Parent = colorPreview
    Utils.CreateStroke(self.Theme.Border).Parent = colorPreview
    
    -- Sliders RGB
    local currentColor = defaultColor or Color3.new(1, 1, 1)
    local r, g, b = currentColor.R, currentColor.G, currentColor.B
    
    -- Slider Rojo
    local rSlider = self:CreateColorSlider("R", r, Color3.new(1, 0, 0), function(value)
        r = value
        currentColor = Color3.new(r, g, b)
        colorPreview.BackgroundColor3 = currentColor
        if callback then callback(currentColor) end
    end)
    rSlider.Position = UDim2.new(0, 0, 0, 30)
    rSlider.Parent = container
    
    -- Slider Verde
    local gSlider = self:CreateColorSlider("G", g, Color3.new(0, 1, 0), function(value)
        g = value
        currentColor = Color3.new(r, g, b)
        colorPreview.BackgroundColor3 = currentColor
        if callback then callback(currentColor) end
    end)
    gSlider.Position = UDim2.new(0, 0, 0, 60)
    gSlider.Parent = container
    
    -- Slider Azul
    local bSlider = self:CreateColorSlider("B", b, Color3.new(0, 0, 1), function(value)
        b = value
        currentColor = Color3.new(r, g, b)
        colorPreview.BackgroundColor3 = currentColor
        if callback then callback(currentColor) end
    end)
    bSlider.Position = UDim2.new(0, 0, 0, 90)
    bSlider.Parent = container
    
    self:UpdateContentSize()
    return container
end

-- Método auxiliar para crear sliders de color
function Karmix:CreateColorSlider(label, value, color, callback)
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, 0, 0, 20)
    slider.BackgroundTransparency = 1
    
    -- Label
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Size = UDim2.new(0, 15, 1, 0)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = label
    sliderLabel.TextColor3 = self.Theme.Text
    sliderLabel.TextSize = 12
    sliderLabel.Font = Enum.Font.SourceSans
    sliderLabel.Parent = slider
    
    -- Fondo del slider
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -50, 0, 6)
    sliderBg.Position = UDim2.new(0, 20, 0.5, -3)
    sliderBg.BackgroundColor3 = self.Theme.Secondary
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = slider
    
    Utils.CreateCorner(3).Parent = sliderBg
    
    -- Barra de color
    local colorBar = Instance.new("Frame")
    colorBar.Size = UDim2.new(value, 0, 1, 0)
    colorBar.BackgroundColor3 = color
    colorBar.BorderSizePixel = 0
    colorBar.Parent = sliderBg
    
    Utils.CreateCorner(3).Parent = colorBar
    
    -- Botón deslizante
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 12, 0, 12)
    sliderButton.Position = UDim2.new(value, -6, 0.5, -6)
    sliderButton.BackgroundColor3 = Color3.new(1, 1, 1)
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.Parent = sliderBg
    
    Utils.CreateCorner(6).Parent = sliderButton
    Utils.CreateStroke(color, 2).Parent = sliderButton
    
    -- Valor numérico
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 30, 1, 0)
    valueLabel.Position = UDim2.new(1, -30, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = math.floor(value * 255)
    valueLabel.TextColor3 = self.Theme.TextSecondary
    valueLabel.TextSize = 12
    valueLabel.Font = Enum.Font.SourceSans
    valueLabel.Parent = slider
    
    -- Lógica del slider
    local dragging = false
    
    local function updateSlider(inputPos)
        local relativePos = math.clamp((inputPos - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        
        Utils.Tween(colorBar, {Size = UDim2.new(relativePos, 0, 1, 0)}, 0.05)
        Utils.Tween(sliderButton, {Position = UDim2.new(relativePos, -6, 0.5, -6)}, 0.05)
        
        valueLabel.Text = math.floor(relativePos * 255)
        
        if callback then
            callback(relativePos)
        end
    end
    
    sliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    sliderButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input.Position.X)
        end
    end)
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            updateSlider(input.Position.X)
        end
    end)
    
    return slider
end

-- Método para crear keybinds
function Karmix:CreateKeybind(text, defaultKey, callback)
    local container = Instance.new("Frame")
    container.Name = "KeybindContainer"
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundColor3 = self.Theme.Surface
    container.BorderSizePixel = 0
    container.Parent = self.ContentFrame
    
    Utils.CreateCorner().Parent = container
    Utils.CreateStroke(self.Theme.Border).Parent = container
    Utils.CreatePadding().Parent = container
    
    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text or "Keybind"
    label.TextColor3 = self.Theme.Text
    label.TextSize = 14
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = container
    
    -- Botón de la tecla
    local keyButton = Instance.new("TextButton")
    keyButton.Size = UDim2.new(0, 70, 0, 25)
    keyButton.Position = UDim2.new(1, -70, 0.5, -12.5)
    keyButton.BackgroundColor3 = self.Theme.Background
    keyButton.BorderSizePixel = 0
    keyButton.Text = defaultKey and defaultKey.Name or "None"
    keyButton.TextColor3 = self.Theme.Text
    keyButton.TextSize = 12
    keyButton.Font = Enum.Font.SourceSans
    keyButton.Parent = container
    
    Utils.CreateCorner(4).Parent = keyButton
    Utils.CreateStroke(self.Theme.Border).Parent = keyButton
    
    local currentKey = defaultKey
    local listening = false
    
    -- Función para escuchar teclas
    local function startListening()
        listening = true
        keyButton.Text = "..."
        keyButton.BackgroundColor3 = self.Theme.Primary
        
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            
            if input.UserInputType == Enum.UserInputType.Keyboard then
                currentKey = input.KeyCode
                keyButton.Text = input.KeyCode.Name
                keyButton.BackgroundColor3 = self.Theme.Background
                listening = false
                connection:Disconnect()
                
                if callback then
                    callback(currentKey)
                end
            end
        end)
    end
    
    keyButton.MouseButton1Click:Connect(function()
        if not listening then
            startListening()
        end
    end)
    
    -- Detectar uso de la tecla
    if currentKey then
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == currentKey then
                if callback then
                    callback(currentKey)
                end
            end
        end)
    end
    
    self:UpdateContentSize()
    return container
end

-- Método para crear tabs
function Karmix:CreateTabSystem()
    local tabSystem = {
        Tabs = {},
        CurrentTab = nil,
        TabButtons = {},
        TabContents = {}
    }
    
    -- Container para los botones de tabs
    local tabBar = Instance.new("Frame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, 0, 0, 35)
    tabBar.BackgroundColor3 = self.Theme.Background
    tabBar.BorderSizePixel = 0
    tabBar.Parent = self.ContentFrame
    
    Utils.CreateCorner().Parent = tabBar
    Utils.CreateStroke(self.Theme.Border).Parent = tabBar
    
    -- Layout para los tabs
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 2)
    tabLayout.Parent = tabBar
    
    Utils.CreatePadding(2).Parent = tabBar
    
    -- Container para el contenido de los tabs
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, 0, 1, -45)
    tabContainer.Position = UDim2.new(0, 0, 0, 40)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = self.ContentFrame
    
    -- Función para crear un nuevo tab
    function tabSystem:CreateTab(name)
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "Button"
        tabButton.Size = UDim2.new(0, 100, 1, 0)
        tabButton.BackgroundColor3 = self.Theme.Surface
        tabButton.BorderSizePixel = 0
        tabButton.Text = name
        tabButton.TextColor3 = self.Theme.Text
        tabButton.TextSize = 14
        tabButton.Font = Enum.Font.SourceSans
        tabButton.Parent = tabBar
        
        Utils.CreateCorner(4).Parent = tabButton
        
        -- Contenido del tab
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = name .. "Content"
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 6
        tabContent.ScrollBarImageColor3 = self.Theme.Primary
        tabContent.Visible = false
        tabContent.Parent = tabContainer
        
        -- Layout para el contenido del tab
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Padding = UDim.new(0, 5)
        contentLayout.Parent = tabContent
        
        Utils.CreatePadding(5).Parent = tabContent
        
        -- Eventos del tab
        tabButton.MouseButton1Click:Connect(function()
            self:SwitchTab(name)
        end)
        
        -- Efectos hover
        tabButton.MouseEnter:Connect(function()
            if self.CurrentTab ~= name then
                Utils.Tween(tabButton, {BackgroundColor3 = self.Theme.Secondary}, 0.1)
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if self.CurrentTab ~= name then
                Utils.Tween(tabButton, {BackgroundColor3 = self.Theme.Surface}, 0.1)
            end
        end)
        
        -- Guardar referencias
        table.insert(self.Tabs, name)
        self.TabButtons[name] = tabButton
        self.TabContents[name] = tabContent
        
        -- Si es el primer tab, activarlo
        if #self.Tabs == 1 then
            self:SwitchTab(name)
        end
        
        return {
            Button = tabButton,
            Content = tabContent,
            
            -- Métodos para agregar componentes al tab
            AddButton = function(text, callback)
                return self:CreateTabButton(tabContent, text, callback)
            end,
            
            AddSlider = function(text, min, max, default, callback)
                return self:CreateTabSlider(tabContent, text, min, max, default, callback)
            end,
            
            AddToggle = function(text, default, callback)
                return self:CreateTabToggle(tabContent, text, default, callback)
            end,
            
            AddTextBox = function(placeholder, callback)
                return self:CreateTabTextBox(tabContent, placeholder, callback)
            end,
            
            AddLabel = function(text)
                return self:CreateTabLabel(tabContent, text)
            end,
            
            AddSeparator = function()
                return self:CreateTabSeparator(tabContent)
            end
        }
    end
    
    -- Función para cambiar de tab
    function tabSystem:SwitchTab(tabName)
        -- Ocultar tab actual
        if self.CurrentTab then
            local currentButton = self.TabButtons[self.CurrentTab]
            local currentContent = self.TabContents[self.CurrentTab]
            
            Utils.Tween(currentButton, {BackgroundColor3 = self.Theme.Surface}, 0.2)
            currentContent.Visible = false
        end
        
        -- Mostrar nuevo tab
        local newButton = self.TabButtons[tabName]
        local newContent = self.TabContents[tabName]
        
        Utils.Tween(newButton, {BackgroundColor3 = self.Theme.Primary}, 0.2)
        newContent.Visible = true
        
        self.CurrentTab = tabName
    end
    
    self:UpdateContentSize()
    return tabSystem
end

-- Métodos para componentes en tabs
function Karmix:CreateTabButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Name = "TabButton"
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = self.Theme.Surface
    button.BorderSizePixel = 0
    button.Text = text or "Button"
    button.TextColor3 = self.Theme.Text
    button.TextSize = 14
    button.Font = Enum.Font.SourceSans
    button.Parent = parent
    
    Utils.CreateCorner().Parent = button
    Utils.CreateStroke(self.Theme.Border).Parent = button
    
    -- Efectos y eventos (similar al CreateButton original)
    button.MouseEnter:Connect(function()
        Utils.Tween(button, {BackgroundColor3 = self.Theme.Primary}, 0.2)
        Utils.Tween(button, {TextColor3 = Color3.new(1, 1, 1)}, 0.2)
    end)
    
    button.MouseLeave:Connect(function()
        Utils.Tween(button, {BackgroundColor3 = self.Theme.Surface}, 0.2)
        Utils.Tween(button, {TextColor3 = self.Theme.Text}, 0.2)
    end)
    
    button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    return button
end

-- Método para actualizar el tamaño del contenido
function Karmix:UpdateContentSize()
    local totalHeight = 0
    for _, child in ipairs(self.ContentFrame:GetChildren()) do
        if child:IsA("GuiObject") and child.Visible then
            totalHeight = totalHeight + child.Size.Y.Offset + 5
        end
    end
    self.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- Métodos de utilidad
function Karmix:Show()
    self.ScreenGui.Enabled = true
    self.MainFrame.Size = UDim2.new(0, 0, 0, 0)
    Utils.Tween(self.MainFrame, {Size = Config.DefaultSize}, 0.3, Enum.EasingStyle.Back)
end

function Karmix:Hide()
    Utils.Tween(self.MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
    wait(0.3)
    self.ScreenGui.Enabled = false
end

function Karmix:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

function Karmix:SetTheme(themeName)
    local newTheme = Themes[themeName]
    if newTheme then
        self.Theme = newTheme
        -- Aquí podrías actualizar todos los colores de la interfaz
        self.MainFrame.BackgroundColor3 = self.Theme.Background
        self.TitleBar.BackgroundColor3 = self.Theme.Primary
        -- ... más actualizaciones de color
    end
end

return Karmix
