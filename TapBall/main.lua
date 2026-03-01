-- Ocultar la barra de estado
display.setStatusBar(display.HiddenStatusBar)

-- Variables globales
local puntuacion = 0
local velocidad = 2 -- Velocidad inicial del circulo
local direccionX = 1
local direccionY = 1

-- *** MEJORAS: VARIABLES NUEVAS ***
local tiempoRestante = 60
local juegoActivo = true
local temporizador
local highScore = 0
local gameOverMostrado = false

-- Agregar fondo
local fondo = display.newImageRect("Fondo.png", display.contentWidth, display.contentHeight)
fondo.x = display.contentCenterX
fondo.y = display.contentCenterY

-- Agregar marcador de puntuacion (ESQUINA SUPERIOR IZQUIERDA)
local marcador = display.newText("Puntos: 0", 20, 20, native.systemFont, 30)
marcador.anchorX = 0 -- Alinear a la izquierda
marcador.anchorY = 0 -- Alinear arriba
marcador:setFillColor(1, 1, 1)

-- *** TEMPORIZADOR (ESQUINA SUPERIOR DERECHA) ***
local tiempoTexto = display.newText("Tiempo: 60", display.contentWidth - 16, 20, native.systemFont, 30)
tiempoTexto.anchorX = 1 -- Alinear a la derecha
tiempoTexto.anchorY = 0 -- Alinear arriba
tiempoTexto:setFillColor(1, 0, 0)

-- *** HIGH SCORE (DEBAJO DEL MARCADOR) ***
local highScoreText = display.newText("Record: 0", 20, 60, native.systemFont, 24)
highScoreText.anchorX = 0
highScoreText.anchorY = 0
highScoreText:setFillColor(4, 0.8, 0)

-- Crear el circulo en movimiento
local circulo = display.newImageRect("Circulo.png", 80, 80)
circulo.x = math.random(80, display.contentWidth - 80)
circulo.y = math.random(80, display.contentHeight - 80)

-- *** FUNCIÓN MODIFICADA: moverCirculo (con verificación de juegoActivo) ***
local function moverCirculo(event)
    -- Solo mover si el juego está activo
    if juegoActivo then
        circulo.x = circulo.x + (velocidad * direccionX)
        circulo.y = circulo.y + (velocidad * direccionY)

        -- Rebotar en los bordes de la pantalla
        if circulo.x >= display.contentWidth - 40 or circulo.x <= 40 then
            direccionX = -direccionX
        end
        if circulo.y >= display.contentHeight - 40 or circulo.y <= 40 then
            direccionY = -direccionY
        end
    end
end

-- *** NUEVA FUNCIÓN: actualizarTiempo ***
local function actualizarTiempo()
    if juegoActivo then
        tiempoRestante = tiempoRestante - 1
        tiempoTexto.text = "Tiempo: " .. tiempoRestante
        
        if tiempoRestante <= 0 and not gameOverMostrado then
            juegoActivo = false
            gameOverMostrado = true
            
            -- Mostrar mensaje simple de Game Over
            local gameOverMsg = display.newText("¡TIEMPO AGOTADO!", display.contentCenterX, display.contentCenterY, native.systemFont, 30)
            gameOverMsg:setFillColor(1, 0, 0)
            
            -- Mensaje para reiniciar
            local reiniciarMsg = display.newText("Toca la pantalla para reiniciar", display.contentCenterX, display.contentCenterY + 60, native.systemFont, 20)
            reiniciarMsg:setFillColor(1, 1, 1)
            
            -- Función para reiniciar al tocar cualquier parte
            local function reiniciarAlTocar()
                -- Eliminar mensajes
                gameOverMsg:removeSelf()
                reiniciarMsg:removeSelf()
                
                -- Reiniciar variables
                puntuacion = 0
                tiempoRestante = 60
                velocidad = 2
                direccionX = 1
                direccionY = 1
                juegoActivo = true
                gameOverMostrado = false
                
                -- Actualizar textos
                marcador.text = "Puntos: 0"
                tiempoTexto.text = "Tiempo: 60"
                
                -- Reubicar círculo
                circulo.x = math.random(80, display.contentWidth - 80)
                circulo.y = math.random(80, display.contentHeight - 80)
                
                -- Reiniciar temporizador
                temporizador = timer.performWithDelay(10000, actualizarTiempo, 0)
                
                -- Quitar este listener
                Runtime:removeEventListener("touch", reiniciarAlTocar)
            end
            
            -- Agregar listener para tocar y reiniciar
            Runtime:addEventListener("touch", reiniciarAlTocar)
        end
    end
end

-- *** FUNCIÓN MODIFICADA: tocarCirculo (con verificación de juegoActivo y high score) ***
local function tocarCirculo(event)
    if event.phase == "began" and juegoActivo then
        puntuacion = puntuacion + 1
        marcador.text = "Puntos: " .. puntuacion
        
        -- Actualizar high score
        if puntuacion > highScore then
            highScore = puntuacion
            highScoreText.text = "Record: " .. highScore
        end
        
        -- Teletransportar círculo
        circulo.x = math.random(80, display.contentWidth - 80)
        circulo.y = math.random(80, display.contentHeight - 80)

        -- Aumentar velocidad cada 10 puntos
        if puntuacion % 10 == 0 then
            velocidad = velocidad + 1
        end
    end
    return true
end

-- Agregar eventos
Runtime:addEventListener("enterFrame", moverCirculo)
circulo:addEventListener("touch", tocarCirculo)

-- Iniciar temporizador
temporizador = timer.performWithDelay(1000, actualizarTiempo, 0)