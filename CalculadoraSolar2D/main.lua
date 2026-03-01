-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here 
--3.1 Ocultal barra de estado
display.setStatusBar(display.HiddenStatusBar)

--3.2 Colores del diseño
local BG = { 0.30, 0.45, 1.00 }
local BLACK = { 0, 0, 0 }
local WHITE = { 1, 1, 1 }

--3.3 Fondo azul
local bg = display.newRect(display.contentCenterX, display.contentCenterY,
    display.actualContentWidth, display.actualContentHeight)
bg:setFillColor(unpack(BG))

--3.4 Safe Area
local safeTop    = display.safeScreenOriginY
local safeLeft   = display.safeScreenOriginX
local safeRight  = display.safeActualContentWidth + safeLeft
local safeBottom = display.safeActualContentHeight + safeTop

local safeW = safeRight - safeLeft
local safeH = safeBottom - safeTop

--PASO 4
--4.1 Etiquetas alineadas a la izquierda
local function makeLabelLeft(text, x, y)
    local t = display.newText({
        text = text,
        x = x, y = y,
        font = native.systemFontBold,
        fontSize = 42
    })
    t.anchorX = 0
    t:setFillColor(unpack(WHITE))
    return t
end
--4.2 Etiqueta cemtrada 
local function makeLabelCenter(text, x, y, size)
    local t = display.newText({
        text = text,
        x = x, y = y,
        font = native.systemFontBold,
        fontSize = size or 46
    })
    t:setFillColor(unpack(BLACK))
    return t
end
--4.3 Input con borde negro y texto alineado a la izquierda 
local function makeInput(x, y, w, h)

    local border = display.newRect(x, y, w, h)
    border:setFillColor(0,0,0,0)
    border.strokeWidth = 4
    border:setStrokeColor(unpack(BLACK))

    local tf = native.newTextField(x, y, w - 12, h - 12)
    tf.inputType = "number"
    tf.hasBackground = false
    tf.align = "left"
    tf.size = 34
    tf:setTextColor(0,0,0)

    tf.anchorX = 0
    tf.x = x - (w - 12)/2 + 10

    return tf, border
end
--4.4 Boton reusable 
local function makeButton(symbol, x, y, size, onTap)
    local r = display.newRect(x, y, size, size)
    r:setFillColor(unpack(BLACK))

    local txt = display.newText({
        text = symbol,
        x = x, y = y,
        font = native.systemFontBold,
        fontSize = 96
    })
    txt:setFillColor(unpack(WHITE))

    r:addEventListener("tap", function()
        onTap()
        return true
    end)
    return r, txt
end

-- 5 convercion y formato de resultado 
local function toNumberOrNil(s)
    if not s or s == "" then return nil end
    s = string.gsub(s, ",", ".")
    return tonumber(s)
end

local function formatNumber(n)
    if n == math.floor(n) then return tostring(n) end
    local s = string.format("%.4f", n)
    s = s:gsub("(.+-)0+$", "%1:"):gsub("%.$", "")
    return s
end

--6 layout proporcional y creacioN  de inputs y resultados 
local marginX = safeLeft + safeW * 0.12
local fieldW = safeW * 0.70
local fieldH = safeH * 0.08

local y1Label = safeTop + safeH * 0.15
local y1Field = safeTop + safeH * 0.23

local y2Label = safeTop + safeH * 0.33
local y2Field = safeTop + safeH * 0.41

local yResTitle = safeTop + safeH * 0.55
local yResValue = safeTop + safeH * 0.60

makeLabelLeft("Numero 1", marginX, y1Label)
local tf1, b1 = makeInput(display.contentCenterX, y1Field, fieldW, fieldH)

makeLabelLeft("Numero 2", marginX, y2Label)
local tf2, b2 = makeInput(display.contentCenterX, y2Field, fieldW, fieldH)

makeLabelCenter("Resultado", display.contentCenterX, yResTitle, 46)

local resValue = display.newText({
    text = "",
    x = display.contentCenterX,
    y = yResValue,
    font = native.systemFontBold,
    fontSize = 40
})

resValue:setFillColor(unpack(WHITE))

--7 Alinamiento ,creacion y conexcion de los botones con las operaciones 
local btnSize = math.min(safeW, safeH) * 0.20
local gapX = safeW * 0.18
local gapY = safeH * 0.12

local centerX = display.contentCenterX
local baseY   = safeTop + safeH * 0.74

local leftX   = centerX - gapX
local rightX = centerX + gapX

local topY    = baseY
local bottomY = baseY + gapY

local function updateResultColor(value)
    if value < 0 then
        resValue:setFillColor(1, 0, 0)  -- Rojo para negativos
    else
        resValue:setFillColor(unpack(WHITE))  -- Blanco para positivos/cero
    end
end

local function operate(op)
    native.setKeyboardFocus(nil)

    local a = toNumberOrNil(tf1.text)
    local b = toNumberOrNil(tf2.text)

    if a == nil or b == nil then
        resValue.text = ""
        native.showAlert("Faltan datos", "Escribe Numero 1 y Numero 2.", {"OK"})
        return
    end

    local r

    if op == "+" then
        r = a + b
    elseif op == "-" then
        r = a - b
    elseif op == "*" or op == "x" then
        r = a * b
    elseif op == "/" then
        if b == 0 then
            native.showAlert("Error", "No se puede dividir entre 0.", {"OK"})
            return
        end
        r = a / b
    end

    resValue.text = formatNumber(r)
    updateResultColor(r)  
end

makeButton("+", leftX, topY, btnSize, function() operate("+") end)
makeButton("-", rightX, topY, btnSize, function() operate("-") end)
makeButton("x", leftX, bottomY, btnSize, function() operate("*") end)
makeButton("/", rightX, bottomY, btnSize, function() operate("/") end)

--8 UX extra 
tf1:addEventListener("userInput", function(e)
    if e.phase == "submitted" then
        native.setKeyboardFocus(tf2)
    end
end)

tf2:addEventListener("userInput", function(e)
    if e.phase == "submitted" then
        native.setKeyboardFocus(nil)
    end
end)

bg:addEventListener("tap", function()
    native.setKeyboardFocus(nil)
    return true
end)



