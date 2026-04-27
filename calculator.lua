local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- สร้าง ScreenGui หลัก
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CalculatorGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- สร้าง Background Frame (สำหรับเลื่อน) - แนวนอน
local bgFrame = Instance.new("Frame")
bgFrame.Name = "BackgroundFrame"
bgFrame.Size = UDim2.new(0, 600, 0, 280)
bgFrame.Position = UDim2.new(0.5, -300, 0.5, -140)
bgFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
bgFrame.BorderSizePixel = 0
bgFrame.Parent = screenGui

-- ไล่เฉดสีเข้มขึ้น (แดง ส้ม เหลือง ขาว - เข้มขึ้น)
local gradientBg = Instance.new("UIGradient")
gradientBg.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),      -- ขาว-เทา (บน)
	ColorSequenceKeypoint.new(0.33, Color3.fromRGB(200, 140, 0)),     -- เหลืองเข้ม
	ColorSequenceKeypoint.new(0.66, Color3.fromRGB(200, 80, 0)),      -- ส้มเข้ม
	ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 20, 20))         -- แดงเข้ม (ล่าง)
})
gradientBg.Rotation = 45  -- มุมเฉียง 45 องศา
gradientBg.Parent = bgFrame

-- ทำให้ dragable (เลื่อนได้อิสระ)
local dragging = false
local dragStart = Vector2.new()
local frameStart = UDim2.new()

bgFrame.InputBegan:Connect(function(input, gameProcessed)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		frameStart = bgFrame.Position
	end
end)

bgFrame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input, gameProcessed)
	if dragging and input.UserInputType == Enum.UserInputType.Mouse then
		local dragDelta = input.Position - dragStart
		bgFrame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + dragDelta.X, frameStart.Y.Scale, frameStart.Y.Offset + dragDelta.Y)
	end
end)

-- สร้าง Header (เครดิต) - ซ้ายสุด - ไม่มีมุมโค้ง
local headerFrame = Instance.new("Frame")
headerFrame.Name = "HeaderFrame"
headerFrame.Size = UDim2.new(0, 80, 1, 0)
headerFrame.Position = UDim2.new(0, 0, 0, 0)
headerFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
headerFrame.BorderSizePixel = 0
headerFrame.Parent = bgFrame

-- รูปเครดิต - วงกลม
local creditImage = Instance.new("ImageLabel")
creditImage.Name = "CreditImage"
creditImage.Size = UDim2.new(0, 55, 0, 55)
creditImage.Position = UDim2.new(0.5, -27.5, 0, 8)
creditImage.BackgroundTransparency = 1
creditImage.Image = "rbxassetid://134810315636739"
creditImage.Parent = headerFrame

-- ทำรูปเป็นวงกลม
local creditImageCorner = Instance.new("UICorner")
creditImageCorner.CornerRadius = UDim.new(1, 0)
creditImageCorner.Parent = creditImage

-- ข้อความ FIATX2 HUB (รวมกัน)
local creditText = Instance.new("TextLabel")
creditText.Name = "CreditText"
creditText.Size = UDim2.new(1, 0, 0, 30)
creditText.Position = UDim2.new(0, 0, 0, 65)
creditText.BackgroundTransparency = 1
creditText.Text = "FIATX2\nHUB"
creditText.TextColor3 = Color3.fromRGB(100, 200, 255)
creditText.TextSize = 10
creditText.Font = Enum.Font.GothamBold
creditText.TextXAlignment = Enum.TextXAlignment.Center
creditText.TextYAlignment = Enum.TextYAlignment.Top
creditText.Parent = headerFrame

-- ปุ่ม X (ปิด)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -40, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Text = "X"
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0
closeButton.Parent = bgFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- ปุ่มเปิด/ปิด UI (ลอย) - ใช้รูปเดิม
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0.5, -25, 1, 5)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.BorderColor3 = Color3.fromRGB(255, 140, 0)
toggleButton.BorderSizePixel = 2
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = ""
toggleButton.TextSize = 0
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = screenGui

-- มุมโค้งของปุ่มเปิด/ปิด
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = toggleButton

-- รูปด้านในปุ่มเปิด/ปิด
local toggleImage = Instance.new("ImageLabel")
toggleImage.Name = "ToggleImage"
toggleImage.Size = UDim2.new(0, 35, 0, 35)
toggleImage.Position = UDim2.new(0.5, -17.5, 0.5, -17.5)
toggleImage.BackgroundTransparency = 1
toggleImage.Image = "rbxassetid://134810315636739"
toggleImage.Parent = toggleButton

local isUIVisible = true

-- ปุ่มเปิด/ปิด UI
toggleButton.MouseButton1Click:Connect(function()
	if isUIVisible then
		bgFrame.Visible = false
		isUIVisible = false
	else
		bgFrame.Visible = true
		isUIVisible = true
	end
end)

-- สร้าง Dialog ยืนยัน
local function createConfirmDialog()
	local dialogGui = Instance.new("ScreenGui")
	dialogGui.Name = "ConfirmDialog"
	dialogGui.ResetOnSpawn = false
	dialogGui.Parent = playerGui
	
	local dialogBg = Instance.new("Frame")
	dialogBg.Name = "DialogBackground"
	dialogBg.Size = UDim2.new(1, 0, 1, 0)
	dialogBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	dialogBg.BackgroundTransparency = 0.5
	dialogBg.BorderSizePixel = 0
	dialogBg.Parent = dialogGui
	
	local dialogFrame = Instance.new("Frame")
	dialogFrame.Name = "DialogFrame"
	dialogFrame.Size = UDim2.new(0, 250, 0, 120)
	dialogFrame.Position = UDim2.new(0.5, -125, 0.5, -60)
	dialogFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	dialogFrame.BorderSizePixel = 0
	dialogFrame.Parent = dialogBg
	
	local dialogCorner = Instance.new("UICorner")
	dialogCorner.CornerRadius = UDim.new(0, 12)
	dialogCorner.Parent = dialogFrame
	
	local dialogText = Instance.new("TextLabel")
	dialogText.Name = "DialogText"
	dialogText.Size = UDim2.new(1, 0, 0, 40)
	dialogText.Position = UDim2.new(0, 0, 0, 10)
	dialogText.BackgroundTransparency = 1
	dialogText.Text = "ปิด UI เครื่องคิดเลข?"
	dialogText.TextColor3 = Color3.fromRGB(255, 255, 255)
	dialogText.TextSize = 14
	dialogText.Font = Enum.Font.Gotham
	dialogText.Parent = dialogFrame
	
	local cancelBtn = Instance.new("TextButton")
	cancelBtn.Name = "CancelButton"
	cancelBtn.Size = UDim2.new(0, 100, 0, 35)
	cancelBtn.Position = UDim2.new(0, 10, 1, -45)
	cancelBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	cancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	cancelBtn.Text = "ยกเลิก"
	cancelBtn.TextSize = 12
	cancelBtn.Font = Enum.Font.GothamBold
	cancelBtn.BorderSizePixel = 0
	cancelBtn.Parent = dialogFrame
	
	local cancelCorner = Instance.new("UICorner")
	cancelCorner.CornerRadius = UDim.new(0, 8)
	cancelCorner.Parent = cancelBtn
	
	local confirmBtn = Instance.new("TextButton")
	confirmBtn.Name = "ConfirmButton"
	confirmBtn.Size = UDim2.new(0, 100, 0, 35)
	confirmBtn.Position = UDim2.new(1, -110, 1, -45)
	confirmBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
	confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	confirmBtn.Text = "ตกลง"
	confirmBtn.TextSize = 12
	confirmBtn.Font = Enum.Font.GothamBold
	confirmBtn.BorderSizePixel = 0
	confirmBtn.Parent = dialogFrame
	
	local confirmCorner = Instance.new("UICorner")
	confirmCorner.CornerRadius = UDim.new(0, 8)
	confirmCorner.Parent = confirmBtn
	
	local result = false
	
	confirmBtn.MouseButton1Click:Connect(function()
		result = true
		dialogGui:Destroy()
	end)
	
	cancelBtn.MouseButton1Click:Connect(function()
		result = false
		dialogGui:Destroy()
	end)
	
	-- รอจนกว่า dialog จะถูกปิด
	while dialogGui.Parent do
		wait(0.1)
	end
	
	return result
end

-- ตัวแปรสำหรับเครื่องคิดเลข
local currentDisplay = "0"
local firstNumber = nil
local operation = nil
local shouldResetDisplay = false

-- สร้าง Display หลัก (แสดงทุกอย่าง)
local displayFrame = Instance.new("Frame")
displayFrame.Name = "DisplayFrame"
displayFrame.Size = UDim2.new(1, -125, 0, 60)
displayFrame.Position = UDim2.new(0, 85, 0, 5)
displayFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
displayFrame.BorderSizePixel = 0
displayFrame.Parent = bgFrame

local displayText = Instance.new("TextLabel")
displayText.Name = "DisplayText"
displayText.Size = UDim2.new(1, -10, 1, 0)
displayText.Position = UDim2.new(0, 5, 0, 0)
displayText.BackgroundTransparency = 1
displayText.Text = "0"
displayText.TextColor3 = Color3.fromRGB(0, 0, 0)
displayText.TextSize = 24
displayText.Font = Enum.Font.GothamBold
displayText.TextXAlignment = Enum.TextXAlignment.Right
displayText.TextYAlignment = Enum.TextYAlignment.Bottom
displayText.TextWrapped = true
displayText.Parent = displayFrame

-- ฟังก์ชันอัพเดต Display
local function updateDisplay()
	if firstNumber ~= nil and operation ~= nil then
		-- แสดง: ตัวเลขตัวแรก + ตัวดำเนินการ + ตัวเลขตัวปัจจุบัน
		displayText.Text = tostring(firstNumber) .. " " .. operation .. "\n" .. currentDisplay
	else
		displayText.Text = currentDisplay
	end
end

-- ฟังก์ชันสร้างปุ่มด้วยมุมโค้ง
local function createButton(text, row, col, callback, buttonColor)
	buttonColor = buttonColor or Color3.fromRGB(50, 50, 60)
	
	local btn = Instance.new("TextButton")
	btn.Name = text
	btn.Size = UDim2.new(0, 55, 0, 40)
	btn.Position = UDim2.new(0, 85 + col * 60, 0, 70 + row * 45)
	btn.BackgroundColor3 = buttonColor
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = text
	btn.TextSize = 14
	btn.Font = Enum.Font.GothamBold
	btn.BorderSizePixel = 0
	btn.Parent = bgFrame
	
	-- เพิ่มมุมโค้ง
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn
	
	btn.MouseButton1Click:Connect(callback)
	
	return btn
end

-- ฟังก์ชันปุ่มตัวเลข
local function numberButtonClick(num)
	if shouldResetDisplay then
		currentDisplay = tostring(num)
		shouldResetDisplay = false
	else
		if currentDisplay == "0" then
			currentDisplay = tostring(num)
		else
			currentDisplay = currentDisplay .. tostring(num)
		end
	end
	updateDisplay()
end

-- ฟังก์ชันปุ่มตัวดำเนินการ
local function operationButtonClick(op)
	local currentNum = tonumber(currentDisplay) or 0
	
	if firstNumber == nil then
		firstNumber = currentNum
	else
		-- ถ้ามีตัวเลขตัวแรกและมี operation อยู่แล้ว ให้คำนวณก่อน
		if operation ~= nil then
			local result = 0
			if operation == "+" then result = firstNumber + currentNum
			elseif operation == "-" then result = firstNumber - currentNum
			elseif operation == "*" then result = firstNumber * currentNum
			elseif operation == "/" then result = firstNumber / currentNum
			end
			firstNumber = result
			currentDisplay = tostring(result)
		end
	end
	
	operation = op
	shouldResetDisplay = true
	updateDisplay()
end

-- ฟังก์ชันเท่ากับ
local function equalsButtonClick()
	if firstNumber ~= nil and operation ~= nil then
		local secondNumber = tonumber(currentDisplay) or 0
		local result = 0
		
		if operation == "+" then result = firstNumber + secondNumber
		elseif operation == "-" then result = firstNumber - secondNumber
		elseif operation == "*" then result = firstNumber * secondNumber
		elseif operation == "/" then result = firstNumber / secondNumber
		end
		
		currentDisplay = tostring(result)
		firstNumber = nil
		operation = nil
		shouldResetDisplay = true
		updateDisplay()
	end
end

-- ฟังก์ชันลบล่าสุด
local function clearButtonClick()
	currentDisplay = "0"
	firstNumber = nil
	operation = nil
	shouldResetDisplay = false
	updateDisplay()
end

-- สร้างปุ่มตัวเลข (แถว 0)
createButton("7", 0, 0, function() numberButtonClick(7) end)
createButton("8", 0, 1, function() numberButtonClick(8) end)
createButton("9", 0, 2, function() numberButtonClick(9) end)
createButton("÷", 0, 3, function() operationButtonClick("/") end, Color3.fromRGB(100, 100, 120))
createButton("C", 0, 4, function() clearButtonClick() end, Color3.fromRGB(150, 100, 100))

-- แถว 1
createButton("4", 1, 0, function() numberButtonClick(4) end)
createButton("5", 1, 1, function() numberButtonClick(5) end)
createButton("6", 1, 2, function() numberButtonClick(6) end)
createButton("×", 1, 3, function() operationButtonClick("*") end, Color3.fromRGB(100, 100, 120))
createButton("⌫", 1, 4, function()
	currentDisplay = string.sub(currentDisplay, 1, -2)
	if currentDisplay == "" then currentDisplay = "0" end
	updateDisplay()
end, Color3.fromRGB(150, 100, 100))

-- แถว 2
createButton("1", 2, 0, function() numberButtonClick(1) end)
createButton("2", 2, 1, function() numberButtonClick(2) end)
createButton("3", 2, 2, function() numberButtonClick(3) end)
createButton("-", 2, 3, function() operationButtonClick("-") end, Color3.fromRGB(100, 100, 120))

-- แถว 3
createButton("0", 3, 0, function() numberButtonClick(0) end)
createButton(".", 3, 1, function() 
	if not string.find(currentDisplay, "%.") then
		currentDisplay = currentDisplay .. "."
		updateDisplay()
	end
end)
createButton("=", 3, 2, function() equalsButtonClick() end, Color3.fromRGB(100, 200, 100))
createButton("+", 3, 3, function() operationButtonClick("+") end, Color3.fromRGB(100, 100, 120))

-- ปุ่มปิด
closeButton.MouseButton1Click:Connect(function()
	local confirmed = createConfirmDialog()
	if confirmed then
		bgFrame.Visible = false
		toggleButton.Visible = true
	end
end)

print("✓ Calculator UI โหลดเสร็จแล้วครับ!")
