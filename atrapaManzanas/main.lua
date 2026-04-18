display.setStatusBar(display.HiddenStatusBar)

--- ============================================
--- VARIABLES BASE
--- ============================================
local CX, CY = display.contentCenterX, display.contentCenterY
local W, H = display.contentWidth, display.contentHeight
math.randomseed(os.time())

--- ============================================
--- CONFIGURACIÓN
--- ============================================
local GRAVITY = 5
local SPAWN_DELAY = 800
local MAX_APPLES = 8
local LIVES = 3

--- ============================================
--- ESCALADO
--- ============================================
local minSide = math.min(W, H)
local playerSize = math.floor(minSide * 0.22)
local appleSize = math.floor(minSide * 0.12)

--- ============================================
--- VARIABLES DEL JUEGO
--- ============================================
local score = 0
local bestScore = 0
local lives = LIVES
local gameActive = true
local apples = {}
local spawnTimer = nil
local targetX = 0

--- ============================================
--- RÉCORD
--- ============================================
local function loadBest()
    local saved = system.getPreference("best", "number")
    if saved then 
        bestScore = saved 
    else
        bestScore = 0
    end
end

local function saveBest()
    if score > bestScore then
        bestScore = score
        system.setPreference("best", "number", bestScore)
    end
end

loadBest()

--- ============================================
--- FONDO
--- ============================================
local fondo = display.newImageRect("bosque.jpg", W, H)
fondo.x, fondo.y = CX, CY

--- ============================================
--- AUDIO
--- ============================================
local biteSound = audio.loadSound("Bite.mp3")
local loseSound = audio.loadSound("Lose.mp3")

--- ============================================
--- JUGADOR
--- ============================================
local player = display.newGroup()
player.x, player.y = CX, H - 80
targetX = player.x

local birdA = display.newImageRect(player, "parrot-a.png", playerSize, playerSize)
local birdB = display.newImageRect(player, "parrot-b.png", playerSize, playerSize)
birdB.alpha = 0

local flap = false
timer.performWithDelay(150, function()
    flap = not flap
    birdA.alpha = flap and 1 or 0
    birdB.alpha = flap and 0 or 1
end, 0)

--- ============================================
--- UI
--- ============================================
local scoreText = display.newText("⭐ PUNTUACION: 0", 20, 20, native.systemFontBold, math.floor(minSide * 0.08))
scoreText.anchorX = 0
scoreText:setFillColor(1, 0.8, 0)

local bestText = display.newText("🏆 RECORD: 0", 20, 80, native.systemFontBold, math.floor(minSide * 0.07))
bestText.anchorX = 0
bestText:setFillColor(1, 0.9, 0.2)

local livesText = display.newText("❤️ VIDAS: " .. lives, W - 20, 20, native.systemFontBold, math.floor(minSide * 0.08))
livesText.anchorX = 1
livesText:setFillColor(1, 0.2, 0.2)

local function updateUI()
    scoreText.text = "⭐ PUNTUACION: " .. score
    livesText.text = "❤️ VIDAS: " .. lives
    bestText.text = "🏆 RECORD: " .. bestScore
end

--- ============================================
--- MANZANAS
--- ============================================
local function spawnApple()
    if not gameActive then return end
    if #apples >= MAX_APPLES then return end
    
    local apple = display.newImageRect("apple.png", appleSize, appleSize)
    apple.x = math.random(appleSize, W - appleSize)
    apple.y = -appleSize
    table.insert(apples, apple)
end

--- ============================================
--- REINICIAR JUEGO
--- ============================================
local function restartGame()
    -- Detener timers
    if spawnTimer then
        timer.cancel(spawnTimer)
        spawnTimer = nil
    end
    
    -- Borrar manzanas
    for i = #apples, 1, -1 do
        if apples[i] then
            apples[i]:removeSelf()
            apples[i] = nil
        end
    end
    apples = {}
    
    -- Reiniciar variables
    score = 0
    lives = LIVES
    gameActive = true
    player.x = CX
    player.y = H - 80
    targetX = CX
    player.alpha = 1
    player.xScale = 1
    
    updateUI()
    
    -- Iniciar timer
    spawnTimer = timer.performWithDelay(SPAWN_DELAY, spawnApple, 0)
end

--- ============================================
--- PERDER VIDA
--- ============================================
local function loseLife()
    if not gameActive then return end
    
    lives = lives - 1
    updateUI()
    
    player.alpha = 0.4
    timer.performWithDelay(150, function() player.alpha = 1 end)
    
    if loseSound then audio.play(loseSound) end
    
    if lives <= 0 then
        gameActive = false
        saveBest()
        
        -- Detener timers
        if spawnTimer then
            timer.cancel(spawnTimer)
            spawnTimer = nil
        end
        
        -- Borrar manzanas
        for i = #apples, 1, -1 do
            if apples[i] then
                apples[i]:removeSelf()
                apples[i] = nil
            end
        end
        apples = {}
        
        -- Pantalla de Game Over
        local dark = display.newRect(CX, CY, W, H)
        dark:setFillColor(0, 0, 0, 0.7)
        
        local goText = display.newText("💀 GAME OVER 💀", CX, CY - 50, native.systemFontBold, math.floor(minSide * 0.1))
        goText:setFillColor(1, 0, 0)
        
        local finalScore = display.newText("PUNTUACION: " .. score, CX, CY + 10, native.systemFontBold, math.floor(minSide * 0.07))
        finalScore:setFillColor(1, 1, 1)
        
        local tapText = display.newText("👇 TOCA PARA REINICIAR 👇", CX, CY + 80, native.systemFontBold, math.floor(minSide * 0.05))
        tapText:setFillColor(1, 1, 1)
        
        local function onTap()
            dark:removeSelf()
            goText:removeSelf()
            finalScore:removeSelf()
            tapText:removeSelf()
            Runtime:removeEventListener("tap", onTap)
            restartGame()
        end
        
        Runtime:addEventListener("tap", onTap)
    end
end

--- ============================================
--- COLISIÓN
--- ============================================
local function checkCollision(apple)
    return math.abs(player.x - apple.x) < (playerSize + appleSize)/2 and
           math.abs(player.y - apple.y) < (playerSize + appleSize)/2
end

local function updateApples()
    for i = #apples, 1, -1 do
        local a = apples[i]
        if a then
            a.y = a.y + GRAVITY
            
            if a.y + appleSize/2 >= H then
                a:removeSelf()
                table.remove(apples, i)
                loseLife()
            elseif checkCollision(a) then
                score = score + 1
                updateUI()
                if biteSound then audio.play(biteSound) end
                a:removeSelf()
                table.remove(apples, i)
            end
        end
    end
end

--- ============================================
--- MOVIMIENTO
--- ============================================
local function onTouch(e)
    if not gameActive then return true end
    if e.phase == "began" or e.phase == "moved" then
        local half = playerSize * 0.5
        targetX = math.max(half, math.min(e.x, W - half))
        
        if e.x < player.x then 
            player.xScale = -1
        elseif e.x > player.x then 
            player.xScale = 1 
        end
    end
    return true
end

Runtime:addEventListener("touch", onTouch)

--- ============================================
--- BUCLE PRINCIPAL
--- ============================================
local function onFrame()
    if not gameActive then return end
    
    player.x = player.x + (targetX - player.x) * 0.3
    updateApples()
end

Runtime:addEventListener("enterFrame", onFrame)

--- ============================================
--- INICIAR JUEGO
--- ============================================
spawnTimer = timer.performWithDelay(SPAWN_DELAY, spawnApple, 0)
updateUI()

local instr = display.newText("🖐️ DESLIZA EL DEDO PARA MOVER 🖐️", CX, H - 50, native.systemFontBold, math.floor(minSide * 0.045))
instr:setFillColor(1, 1, 1, 0.7)

timer.performWithDelay(3000, function()
    if instr then
        transition.to(instr, {time=500, alpha=0, onComplete=function() instr:removeSelf() end})
    end
end)