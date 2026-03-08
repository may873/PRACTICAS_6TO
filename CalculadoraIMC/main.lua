-- CONFIGURACION INICIAL
display.setDefault("background", 0, 0, 0) -- Negro

-- TITULO
local titulo = display.newText({
    text = "Calculadora de IMC",
    x = display.contentCenterX,
    y = 40,
    font = native.systemFontBold,
    fontSize = 28
})
titulo:setFillColor(1, 1, 1) -- Blanco

-------------------------------------------------
-- ETIQUETAS PARA LOS CAMPOS DE ENTRADA (ALINEADAS A LA IZQUIERDA CON SEPARACION)
local etiquetaPeso = display.newText({
    text = "Peso (kg):",
    x = display.contentCenterX - 110,
    y = 65, -- Ligeramente más arriba para separar del input
    font = native.systemFont,
    fontSize = 16
})
etiquetaPeso:setFillColor(1, 1, 1) -- Blanco

-- CAMPOS DE ENTRADA
local peso = native.newTextField(display.contentCenterX, 105, 220, 40) -- Ligeramente más abajo
peso.placeholder = "Peso (kg)"
peso.inputType = "decimal"

local etiquetaAltura = display.newText({
    text = "Altura (m):",
    x = display.contentCenterX - 110,
    y = 133, -- Ligeramente más arriba para separar del input
    font = native.systemFont,
    fontSize = 16
})
etiquetaAltura:setFillColor(1, 1, 1) -- Blanco

local altura = native.newTextField(display.contentCenterX, 165, 220, 40) -- Ligeramente más abajo
altura.placeholder = "Altura (m)"
altura.inputType = "decimal"

-------------------------------------------------
-- GRAFICO CIRCULAR (solo la circunferencia)
local radio = 80
local centroX = display.contentCenterX
local centroY = 280
local grosorLinea = 8

-- Circulo base (gris) - solo el borde
local circuloBase = display.newCircle(centroX, centroY, radio)
circuloBase:setFillColor(0, 0, 0, 0) -- Transparente
circuloBase.strokeWidth = grosorLinea
circuloBase:setStrokeColor(0.3, 0.3, 0.3) -- Gris oscuro

-- Circulo que se colorea (inicialmente vacio)
local circuloColor = display.newCircle(centroX, centroY, radio)
circuloColor:setFillColor(0, 0, 0, 0) -- Transparente
circuloColor.strokeWidth = grosorLinea
circuloColor:setStrokeColor(0.5, 0.5, 0.5) -- Color temporal

-- Texto del IMC dentro del circulo
local textoIMC = display.newText({
    text = "0.0",
    x = centroX,
    y = centroY - 15,
    font = native.systemFontBold,
    fontSize = 32
})
textoIMC:setFillColor(1, 1, 1) -- Blanco

-- Texto de categoria debajo del IMC
local textoCategoria = display.newText({
    text = "---",
    x = centroX,
    y = centroY + 20,
    font = native.systemFont,
    fontSize = 18
})
textoCategoria:setFillColor(1, 1, 1) -- Blanco

-------------------------------------------------
-- TEXTO PARA FRASE MOTIVADORA (MUY POR DEBAJO DEL CIRCULO)
local fraseMotivadora = display.newText({
    text = "Ingresa tus datos",
    x = centroX,
    y = 420,
    font = native.systemFont,
    fontSize = 20,
    width = 320,
    align = "center"
})
fraseMotivadora:setFillColor(1, 1, 1) -- Blanco

-- Texto para mensajes de error
local mensajeError = display.newText({
    text = "",
    x = centroX,
    y = 460,
    font = native.systemFont,
    fontSize = 16
})
mensajeError:setFillColor(1, 0, 0) -- Rojo

-------------------------------------------------
-- FUNCION PARA OBTENER FRASE MOTIVADORA SEGUN CATEGORIA (UNA POR CATEGORIA)
local function obtenerFraseMotivadora(categoria)
    local frases = {
        ["Bajo peso"] = "¡Ánimo! Cada paso cuenta hacia tu bienestar 💪",
        ["Peso normal"] = "¡Excelente! Mantén tu estilo de vida saludable 🌟",
        ["Sobrepeso"] = "¡Tú puedes lograrlo! Un paso a la vez 🚶",
        ["Obesidad"] = "Hoy es el primer día para cambiar el resto de tu vida 🌈"
    }
    
    return frases[categoria] or "¡Cuida tu salud!"
end

-------------------------------------------------
-- FUNCION PARA VALIDAR CAMPOS
local function validarCampos(pesoValor, alturaValor)
    -- Validar campos vacios
    if peso.text == "" or altura.text == "" then
        mensajeError.text = "Error: Complete todos los campos"
        fraseMotivadora.text = "¿Listo para calcular tu IMC?"
        return false
    end
    
    -- Validar que sean numeros
    if not pesoValor or not alturaValor then
        mensajeError.text = "Error: Ingrese solo numeros validos"
        fraseMotivadora.text = "Usa puntos para decimales (ej: 1.75)"
        return false
    end
    
    -- Validar valores negativos
    if pesoValor < 0 or alturaValor < 0 then
        mensajeError.text = "Error: No se permiten valores negativos"
        fraseMotivadora.text = "Los valores deben ser positivos"
        return false
    end
    
    -- Validar valores cero
    if pesoValor == 0 or alturaValor == 0 then
        mensajeError.text = "Error: Los valores no pueden ser cero"
        fraseMotivadora.text = "Ingresa valores mayores a cero"
        return false
    end
    
    -- Validar valores minimos realistas
    if pesoValor < 1 then
        mensajeError.text = "Error: El peso debe ser mayor a 1 kg"
        fraseMotivadora.text = "¿Seguro que pesas menos de 1 kg?"
        return false
    end
    
    if alturaValor < 0.5 then
        mensajeError.text = "Error: La altura debe ser mayor a 0.5 m"
        fraseMotivadora.text = "La altura minima es 0.5 metros"
        return false
    end
    
    -- Validar valores maximos realistas (opcional)
    if pesoValor > 300 then
        mensajeError.text = "Advertencia: El peso es muy alto"
        fraseMotivadora.text = "Consulta con un profesional de salud"
        return true -- Aun asi permitimos el calculo
    end
    
    if alturaValor > 2.5 then
        mensajeError.text = "Advertencia: La altura es muy alta"
        fraseMotivadora.text = "Verifica que la altura sea correcta"
        return true -- Aun asi permitimos el calculo
    end
    
    -- Si todo esta bien, limpiar mensaje de error
    mensajeError.text = ""
    return true
end

-------------------------------------------------
-- FUNCION PARA ACTUALIZAR EL GRAFICO
local function actualizarGrafico(imc)
    -- Determinar color y angulo segun IMC
    local color = {1, 1, 0} -- Amarillo por defecto
    local anguloFinal = 0
    local categoria = ""
    
    if imc < 18.5 then -- Bajo peso
        color = {1, 1, 0} -- Amarillo
        anguloFinal = (imc / 18.5) * 360
        categoria = "Bajo peso"
    elseif imc < 25 then -- Normal
        color = {0, 1, 0} -- Verde
        anguloFinal = ((imc - 18.5) / (25 - 18.5)) * 360
        categoria = "Peso normal"
    elseif imc < 30 then -- Sobrepeso
        color = {1, 0.5, 0} -- Naranja
        anguloFinal = ((imc - 25) / (30 - 25)) * 360
        categoria = "Sobrepeso"
    else -- Obesidad
        color = {1, 0, 0} -- Rojo
        anguloFinal = math.min(((imc - 30) / 10) * 360, 360) -- Maximo 360 grados
        categoria = "Obesidad"
    end
    
    -- Limitar angulo entre 0 y 360
    anguloFinal = math.max(0, math.min(360, anguloFinal))
    
    -- Actualizar el color del circulo
    circuloColor:setStrokeColor(color[1], color[2], color[3])
    
    -- Crear efecto de arco progresivo
    circuloColor.rotation = -90 -- Comenzar desde arriba
    circuloColor:rotate(anguloFinal)
    
    -- Actualizar textos
    textoIMC.text = string.format("%.1f", imc)
    textoCategoria.text = categoria
    
    -- Cambiar color del texto del IMC segun la categoria
    textoIMC:setFillColor(color[1], color[2], color[3])
    
    -- Obtener y mostrar frase motivadora (una por categoria)
    local frase = obtenerFraseMotivadora(categoria)
    fraseMotivadora.text = frase
    fraseMotivadora:setFillColor(color[1], color[2], color[3])
end

-------------------------------------------------
-- FUNCION PARA CALCULAR IMC
local function calcularIMC()
    -- Obtener valores de los campos
    local p = tonumber(peso.text)
    local h = tonumber(altura.text)
    
    -- Validar campos
    if not validarCampos(p, h) then
        -- Si hay error, resetear grafico
        circuloColor:setStrokeColor(0.5, 0.5, 0.5)
        circuloColor.rotation = -90
        textoIMC.text = "?"
        textoIMC:setFillColor(1, 0, 0) -- Rojo para indicar error
        textoCategoria.text = "Error"
        return
    end

    -- Calculo del IMC
    local imc = p / (h * h)
    imc = math.floor(imc * 10) / 10 -- Redondeo 1 decimal

    -- Validar que el IMC sea razonable
    if imc > 60 then
        mensajeError.text = "IMC muy alto"
    elseif imc < 10 then
        mensajeError.text = "IMC muy bajo"
    else
        mensajeError.text = ""
    end

    -- Actualizar grafico con el IMC calculado
    actualizarGrafico(imc)
end

-- FUNCION PARA LIMPIAR CAMPOS
local function limpiar()
    peso.text = ""
    altura.text = ""
    
    -- Resetear grafico
    circuloColor:setStrokeColor(0.5, 0.5, 0.5)
    circuloColor.rotation = -90
    
    textoIMC.text = "0.0"
    textoIMC:setFillColor(1, 1, 1)
    textoCategoria.text = "---"
    mensajeError.text = ""
    fraseMotivadora.text = "Ingresa tus datos"
    fraseMotivadora:setFillColor(1, 1, 1)
end

-------------------------------------------------
-- BOTONES
local btnCalcular = display.newText({
    text = "Calcular IMC",
    x = display.contentCenterX - 80,
    y = 500,
    font = native.systemFontBold,
    fontSize = 22
})
btnCalcular:setFillColor(0, 1, 0) -- Verde
btnCalcular:addEventListener("tap", calcularIMC)

local btnLimpiar = display.newText({
    text = "Limpiar",
    x = display.contentCenterX + 80,
    y = 500,
    font = native.systemFontBold,
    fontSize = 22
})
btnLimpiar:setFillColor(1, 1, 0) -- Amarillo
btnLimpiar:addEventListener("tap", limpiar)
