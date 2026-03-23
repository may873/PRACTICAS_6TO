-- Cargar widget para el scroll
local widget = require("widget")

-- Configurar pantalla
display.setStatusBar(display.HiddenStatusBar)
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenW = display.contentWidth
local screenH = display.contentHeight

-- ==================== FONDO ====================
local fondo = display.newRect(0, 0, screenW, screenH)
fondo.x = centerX
fondo.y = centerY
fondo:setFillColor(0, 0.1, 0.25)

-- ==================== SCROLL VIEW ====================
local scrollView = widget.newScrollView({
    top = 0,
    left = 0,
    width = screenW,
    height = screenH,
    scrollWidth = screenW,
    scrollHeight = 1135,
    horizontalScrollDisabled = true,
    verticalScrollDisabled = false,
    backgroundColor = { 0, 0.1, 0.25 }
})

-- Grupo para contener todo
local grupo = display.newGroup()
scrollView:insert(grupo)

-- Posición Y inicial
local y = 20

-- ==================== TÍTULO ====================
local titulo = display.newText({
    text = "⚕️ MISIÓN MÉDICA SUBMARINA ⚕️",
    x = centerX,
    y = y,
    font = native.systemFontBold,
    fontSize = 22
})
titulo:setFillColor(1, 1, 1)
grupo:insert(titulo)

y = y + 45

-- ==================== VARIABLES ====================
local sintomaSeleccionado = "Mareo intenso"
local presionSeleccionada = "Cambio brusco de profundidad"
local oxigenoSeleccionado = "Bajo"

-- Variables para los textos de selección actual
local textoSintoma
local textoPresion
local textoOxigeno

-- ==================== MENÚ 1: SÍNTOMAS ====================
local labelSintoma = display.newText({
    text = "📋 SÍNTOMA PRINCIPAL",
    x = centerX,
    y = y,
    font = native.systemFontBold,
    fontSize = 16
})
labelSintoma:setFillColor(0.7, 0.9, 1)
grupo:insert(labelSintoma)

y = y + 28

-- Mostrar selección actual
textoSintoma = display.newText({
    text = sintomaSeleccionado,
    x = centerX,
    y = y,
    font = native.systemFontBold,
    fontSize = 14
})
textoSintoma:setFillColor(1, 1, 0.7)
grupo:insert(textoSintoma)

y = y + 32

-- Botones de síntomas
local sintomas = {"Mareo intenso", "Dolor articular", "Dificultad para respirar", "Convulsiones", "Dolor de oído"}
local botonesSintomas = {}
local botonY = y

for i, sintoma in ipairs(sintomas) do
    local boton = display.newRoundedRect(centerX, botonY, 280, 38, 8)
    boton:setFillColor(0.2, 0.4, 0.6)
    grupo:insert(boton)
    
    local texto = display.newText({
        text = sintoma,
        x = centerX,
        y = botonY,
        font = native.systemFont,
        fontSize = 14
    })
    texto:setFillColor(1, 1, 1)
    grupo:insert(texto)
    
    boton:addEventListener("tap", function()
        sintomaSeleccionado = sintoma
        textoSintoma.text = sintoma
        for _, btn in ipairs(botonesSintomas) do
            btn.boton:setFillColor(0.2, 0.4, 0.6)
        end
        boton:setFillColor(0.3, 0.6, 0.9)
    end)
    
    table.insert(botonesSintomas, {boton = boton, texto = texto})
    botonY = botonY + 45
end

botonesSintomas[1].boton:setFillColor(0.3, 0.6, 0.9)

y = botonY + 20

-- ==================== MENÚ 2: PRESIÓN ====================
local labelPresion = display.newText({
    text = "🌊 CONDICIÓN DE PRESIÓN",
    x = centerX,
    y = y,
    font = native.systemFontBold,
    fontSize = 16
})
labelPresion:setFillColor(0.7, 0.9, 1)
grupo:insert(labelPresion)

y = y + 28

textoPresion = display.newText({
    text = presionSeleccionada,
    x = centerX,
    y = y,
    font = native.systemFontBold,
    fontSize = 14
})
textoPresion:setFillColor(1, 1, 0.7)
grupo:insert(textoPresion)

y = y + 32

local presiones = {"Cambio brusco de profundidad", "Profundidad mayor a 30m", "Ascenso rápido", "Presión normal"}
local botonesPresion = {}
local botonY2 = y

for i, presion in ipairs(presiones) do
    local boton = display.newRoundedRect(centerX, botonY2, 280, 38, 8)
    boton:setFillColor(0.2, 0.4, 0.6)
    grupo:insert(boton)
    
    local texto = display.newText({
        text = presion,
        x = centerX,
        y = botonY2,
        font = native.systemFont,
        fontSize = 14
    })
    texto:setFillColor(1, 1, 1)
    grupo:insert(texto)
    
    boton:addEventListener("tap", function()
        presionSeleccionada = presion
        textoPresion.text = presion
        for _, btn in ipairs(botonesPresion) do
            btn.boton:setFillColor(0.2, 0.4, 0.6)
        end
        boton:setFillColor(0.3, 0.6, 0.9)
    end)
    
    table.insert(botonesPresion, {boton = boton, texto = texto})
    botonY2 = botonY2 + 45
end

botonesPresion[1].boton:setFillColor(0.3, 0.6, 0.9)

y = botonY2 + 20

-- ==================== MENÚ 3: OXÍGENO ====================
local labelOxigeno = display.newText({
    text = "💨 NIVEL DE OXÍGENO",
    x = centerX,
    y = y,
    font = native.systemFontBold,
    fontSize = 16
})
labelOxigeno:setFillColor(0.7, 0.9, 1)
grupo:insert(labelOxigeno)

y = y + 28

textoOxigeno = display.newText({
    text = oxigenoSeleccionado,
    x = centerX,
    y = y,
    font = native.systemFontBold,
    fontSize = 14
})
textoOxigeno:setFillColor(1, 1, 0.7)
grupo:insert(textoOxigeno)

y = y + 32

local oxigenos = {"Bajo", "Normal", "Alto"}
local botonesOxigeno = {}
local botonY3 = y

for i, oxigeno in ipairs(oxigenos) do
    local boton = display.newRoundedRect(centerX, botonY3, 280, 38, 8)
    boton:setFillColor(0.2, 0.4, 0.6)
    grupo:insert(boton)
    
    local texto = display.newText({
        text = oxigeno,
        x = centerX,
        y = botonY3,
        font = native.systemFont,
        fontSize = 14
    })
    texto:setFillColor(1, 1, 1)
    grupo:insert(texto)
    
    boton:addEventListener("tap", function()
        oxigenoSeleccionado = oxigeno
        textoOxigeno.text = oxigeno
        for _, btn in ipairs(botonesOxigeno) do
            btn.boton:setFillColor(0.2, 0.4, 0.6)
        end
        boton:setFillColor(0.3, 0.6, 0.9)
    end)
    
    table.insert(botonesOxigeno, {boton = boton, texto = texto})
    botonY3 = botonY3 + 45
end

botonesOxigeno[1].boton:setFillColor(0.3, 0.6, 0.9)

y = botonY3 + 50

-- ==================== BOTÓN ANALIZAR ====================
local botonAnalizar = display.newRoundedRect(centerX, y, 240, 55, 28)
botonAnalizar:setFillColor(0.2, 0.55, 0.85)
grupo:insert(botonAnalizar)

local textoBoton = display.newText({
    text = "🔍 ANALIZAR CASO",
    x = centerX,
    y = y,
    font = native.systemFontBold,
    fontSize = 18
})
textoBoton:setFillColor(1, 1, 1)
grupo:insert(textoBoton)

local posBotonY = y

-- ==================== ÁREA DE RESULTADOS (BAJADO 10px MÁS) ====================
-- Antes: yResultados = posBotonY + 55 + 70 (125px de separación)
-- Ahora: yResultados = posBotonY + 55 + 80 (135px de separación, 10px más abajo)
local yResultados = posBotonY + 55 + 80

local panelResultados = display.newRoundedRect(centerX, yResultados, screenW - 30, 210, 12)
panelResultados:setFillColor(0.05, 0.1, 0.2)
panelResultados.strokeWidth = 2
panelResultados:setStrokeColor(0.4, 0.7, 1)
grupo:insert(panelResultados)

local tituloDiagnostico = display.newText({
    text = "🔬 DIAGNÓSTICO PROBABLE",
    x = centerX,
    y = yResultados - 75,
    font = native.systemFontBold,
    fontSize = 14
})
tituloDiagnostico:setFillColor(0.5, 0.8, 1)
grupo:insert(tituloDiagnostico)

local diagnostico = display.newText({
    text = "Esperando datos...",
    x = centerX,
    y = yResultados - 50,
    font = native.systemFontBold,
    fontSize = 14,
    width = screenW - 50,
    align = "center"
})
diagnostico:setFillColor(1, 1, 0.7)
grupo:insert(diagnostico)

local tituloRecomendacion = display.newText({
    text = "💡 RECOMENDACIÓN INMEDIATA",
    x = centerX,
    y = yResultados + 15,
    font = native.systemFontBold,
    fontSize = 14
})
tituloRecomendacion:setFillColor(0.5, 0.8, 1)
grupo:insert(tituloRecomendacion)

local recomendacion = display.newText({
    text = "Seleccione opciones y presione Analizar",
    x = centerX,
    y = yResultados + 55,
    font = native.systemFont,
    fontSize = 12,
    width = screenW - 50,
    align = "center"
})
recomendacion:setFillColor(0.9, 0.9, 1)
grupo:insert(recomendacion)

y = yResultados + 140

-- ==================== PIE DE PÁGINA ====================
local footer = display.newText({
    text = "Protocolos de medicina hiperbárica | Desliza para navegar | 16 Diagnósticos",
    x = centerX,
    y = y,
    font = native.systemFont,
    fontSize = 9
})
footer:setFillColor(0.5, 0.6, 0.7)
grupo:insert(footer)

-- ==================== LÓGICA DE DIAGNÓSTICO ====================
local function obtenerDiagnostico()
    local s = sintomaSeleccionado
    local p = presionSeleccionada
    local o = oxigenoSeleccionado
    
    if s == "Mareo intenso" and p == "Profundidad mayor a 30m" and o == "Bajo" then
        return "HIPOXIA SEVERA + NARCOSIS POR NITRÓGENO", "⚠️ URGENTE: Administrar oxígeno al 100% inmediatamente. Reducir profundidad lentamente. Activar protocolo de emergencia médica."
    end
    
    if s == "Mareo intenso" and p == "Profundidad mayor a 30m" and o == "Normal" then
        return "NARCOSIS POR NITRÓGENO (Síndrome de profundidad)", "Reducir profundidad inmediatamente. El mareo debe desaparecer al disminuir presión. No ascender solo."
    end
    
    if s == "Mareo intenso" and p == "Cambio brusco de profundidad" and o == "Bajo" then
        return "HIPOXIA AGUDA + DISBARISMO", "🆘 ¡EMERGENCIA! Oxígeno al 100%. Estabilizar profundidad. Evaluación neurológica urgente."
    end
    
    if s == "Mareo intenso" and p == "Cambio brusco de profundidad" and o == "Normal" then
        return "DISBARISMO POR CAMBIO DE PRESIÓN", "Mantener profundidad estable. Reposo. El mareo debe ceder en 10-15 minutos. Monitorear síntomas."
    end
    
    if s == "Mareo intenso" and p == "Ascenso rápido" then
        return "SÍNDROME DE DESCOMPRESIÓN AGUDA", "⚠️ EVACUACIÓN. Reposo absoluto. Oxígeno suplementario. Evaluar cámara hiperbárica."
    end
    
    if s == "Dolor articular" and p == "Cambio brusco de profundidad" then
        return "ENFERMEDAD POR DESCOMPRESIÓN (ED) Tipo I - Articular", "🚨 EVACUACIÓN URGENTE. Reposo absoluto. Administrar oxígeno al 100%. Preparar cámara hiperbárica."
    end
    
    if s == "Dolor articular" and p == "Profundidad mayor a 30m" then
        if o == "Bajo" then
            return "ED TIPO I + HIPOXIA TISULAR", "Oxígeno al 100%. Evacuación. Analgésicos. No movilizar articulación afectada."
        else
            return "ENFERMEDAD POR DESCOMPRESIÓN (ED) Tipo I", "Reposo. Oxígeno suplementario. Evaluación médica. Posible tratamiento hiperbárico."
        end
    end
    
    if s == "Dificultad para respirar" and o == "Bajo" then
        if p == "Profundidad mayor a 30m" then
            return "EDEMA PULMONAR POR INMERSIÓN + HIPOXIA", "🆘 ¡CÓDIGO AZUL! Oxígeno al 100%. Evacuación inmediata. Posición semi-sentado."
        else
            return "HIPOXIA AGUDA RESPIRATORIA", "🆘 ¡EMERGENCIA! Administrar oxígeno inmediato. Evacuar a superficie. Revisar soporte vital."
        end
    end
    
    if s == "Dificultad para respirar" and o == "Normal" then
        return "EDEMA PULMONAR POR INMERSIÓN", "Mantener al paciente sentado. Administrar oxígeno. Monitorear saturación. Evaluar evacuación médica."
    end
    
    if s == "Convulsiones" and o == "Alto" then
        return "TOXICIDAD POR OXÍGENO (OXTOX) - SNC", "⚠️ ¡EMERGENCIA! Reducir fracción de oxígeno inmediatamente. Suspender inmersión. Monitoreo neurológico."
    end
    
    if s == "Convulsiones" and p == "Profundidad mayor a 30m" and o == "Normal" then
        return "SÍNDROME CONVULSIVO POR NARCOSIS", "Ascender lentamente. Ambiente tranquilo. Proteger vía aérea. Evaluación neurológica urgente."
    end
    
    if s == "Dolor de oído" and p == "Ascenso rápido" then
        return "BAROTRAUMATISMO ÓTICO AGUDO", "No intentar nuevo ascenso/descenso. Reposo absoluto. Evaluación otorrinolaringológica. Evitar vuelos en 48h."
    end
    
    if s == "Dolor de oído" and p == "Cambio brusco de profundidad" then
        return "BAROTRAUMATISMO ÓTICO POR COMPRESIÓN", "Descongestionantes nasales. Evitar maniobras de compensación forzada. Evaluación médica."
    end
    
    if s == "Mareo intenso" and p == "Presión normal" and o == "Bajo" then
        return "HIPOXIA POR ESFUERZO", "Reposo. Oxígeno suplementario. Hidratación. Evaluar niveles de hemoglobina."
    end
    
    if s == "Dificultad para respirar" and p == "Ascenso rápido" then
        return "SOBREINFLACIÓN PULMONAR", "⚠️ EVACUACIÓN. Oxígeno al 100%. No sumergir. Evaluación torácica. Riesgo de neumotórax."
    end
    
    if s == "Convulsiones" and p == "Presión normal" and o == "Bajo" then
        return "CONVULSIÓN HIPÓXICA", "Proteger vía aérea. Oxígeno al 100%. Evaluación neurológica. Descartar otras causas."
    end
    
    return "DESORIENTACIÓN POR AMBIENTE EXTREMO", "Sentar al paciente. Revisar profundidad, presión y oxígeno. Mantener monitoreo constante. Reportar a coordinación de base."
end

local function analizarCaso()
    local diag, reco = obtenerDiagnostico()
    diagnostico.text = diag
    recomendacion.text = reco
    
    if string.find(diag, "URGENTE") or string.find(diag, "EMERGENCIA") or string.find(diag, "EVACUACIÓN") or string.find(diag, "CÓDIGO AZUL") then
        panelResultados:setStrokeColor(1, 0.2, 0.2)
        panelResultados.strokeWidth = 3
    else
        panelResultados:setStrokeColor(0.4, 0.7, 1)
        panelResultados.strokeWidth = 2
    end
end

botonAnalizar:addEventListener("tap", analizarCaso)

