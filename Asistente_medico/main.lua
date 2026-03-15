-- Asistente Médico - Solar2D (main.lua)
display.setStatusBar(display.HiddenStatusBar)

local widget = require("widget")
local media  = require("media")

local cx, cy = display.contentCenterX, display.contentCenterY
local W, H   = display.contentWidth, display.contentHeight

-- Fondo
local fondo = display.newImageRect("fondo_clinica.png", W, H)
fondo.x = cx
fondo.y = cy

-- Texto inicial
local texto = display.newText({
  text = "Selecciona una emergencia para obtener ayuda.",
  x = cx,
  y = 80,
  width = math.min(300, W - 40),
  font = native.systemFont,
  fontSize = 18,
  align = "center"
})
texto:setFillColor(1,1,1)

--------------------------------------------------------------------------------
-- Crear ScrollView para los botones
local scrollView = widget.newScrollView({
    x = cx,
    y = cy + 40,
    width = W,
    height = H - 150,  -- Deja espacio para el botón de emergencias
    horizontalScrollDisabled = true,
    backgroundColor = {0,0,0,0},
    hideBackground = true,
    topPadding = 20,
    bottomPadding = 20
})

--------------------------------------------------------------------------------
-- Funciones
local function reproducirVideo(nombreVideo)
  local path = system.pathForFile(nombreVideo, system.ResourceDirectory)

  if not path then
    native.showAlert("Error", "No se encontró el archivo:\n"..nombreVideo, {"OK"})
    return
  end

  media.playVideo(path, system.ResourceDirectory, true)
end

local function mostrarInstrucciones(titulo, mensaje, video)
  local function listener(event)
    if event.action == "clicked" then
      reproducirVideo(video)
    end
  end

  native.showAlert(titulo, mensaje, {"Ver Video"}, listener)
end

local function crearBoton(titulo, x, y, imagen, mensaje, video)
  -- Crear un grupo dentro del scrollView
  local grupo = display.newGroup()
  
  local boton = widget.newButton({
    label = titulo,
    x = 0, y = 0,
    width = 220, height = 60,
    shape = "roundedRect",
    cornerRadius = 10,
    fillColor = { default = {0.2, 0.6, 1}, over = {0.1, 0.4, 0.8} },
    labelColor = { default = {1}, over = {0.9} },
    fontSize = 16,
    onRelease = function()
      mostrarInstrucciones(titulo, mensaje, video)
      return true
    end
  })
  grupo:insert(boton)

  -- Verificar que la imagen existe antes de crearla
  local path = system.pathForFile(imagen, system.ResourceDirectory)
  if path then
    local icono = display.newImageRect(imagen, 40, 40)
    icono.x = -100
    icono.y = 0
    grupo:insert(icono)
  else
    print("Imagen no encontrada:", imagen)
  end

  -- Posicionar el grupo y agregarlo al scrollView
  grupo.x = x
  grupo.y = y
  scrollView:insert(grupo)
end

-- Botones (NOMBRES EXACTOS)
crearBoton(
  "RCP",
  cx, 50,  -- Y relativo al scrollView
  "icon_rcp.png",
  "1. Verifica si no respira.\n2. Llama al 911.\n3. Inicia compresiones.",
  "RCP.mp4"
)

crearBoton(
  "Heridas",
  cx, 130,  -- 50 + 80
  "icon_corte.png",
  "1. Lava con agua y jabón.\n2. Aplica presión.\n3. Cubre con venda.",
  "HERIDA.mp4"
)

crearBoton(
  "Quemaduras",
  cx, 210,  -- 130 + 80
  "icon_quemadura.png",
  "1. Enfría con agua.\n2. No revientes ampollas.\n3. Cubre con gasa.",
  "QUEMADURA.mp4"
)

crearBoton(
  "Asfixia",
  cx, 290,  -- 210 + 80
  "icon_atragantamiento.png",
  "1. Golpea la espalda.\n2. Aplica Heimlich si es necesario.",
  "ASFIXIA.mp4"
)

-- NUEVOS BOTONES AGREGADOS
crearBoton(
  "Desmayo",
  cx, 370,  -- 290 + 80
  "icon_desmayo.png",
  "1. Acuesta a la persona boca arriba.\n2. Eleva las piernas 30 cm.\n3. Afloja ropa ajustada.",
  "DESMAYO.mp4"
)

crearBoton(
  "Crisis de Ansiedad",
  cx, 450,  -- 370 + 80
  "icon_ansiedad.png",
  "1. Lleva a un lugar tranquilo.\n2. Ayuda a respirar lento.\n3. Habla con voz calmada.",
  "ANSIEDAD.mp4"
)

crearBoton(
  "Picadura de mosquito",
  cx, 530,  -- 450 + 80
  "icon_mosquito.png",
  "1. Lava con agua y jabón.\n2. Aplica hielo envuelto.\n3. No rasques.",
  "MOSQUITO.mp4"
)

--------------------------------------------------------------------------------
-- Botón Emergencias (FUERA del scrollView, fijo abajo)
local function mostrarNumerosEmergencia()
  local mensaje =
    "🚨 Emergencias: 911\n" ..
    "🚑 Cruz Roja: 55 53 95 11 11\n" ..
    "📍 LOCATEL: 55 56 58 11 11\n" ..
    "🔥 Incendios: 800 46 23 63 46"

  native.showAlert("Números de Emergencia", mensaje, {"OK"})
end

widget.newButton({
  label = "Números de Emergencia",
  x = cx, y = H - 50,  -- Siempre al fondo de la pantalla
  width = 250, height = 50,
  shape = "roundedRect",
  cornerRadius = 10,
  fillColor = { default = {1, 0, 0}, over = {0.8, 0, 0} },
  labelColor = { default = {1}, over = {0.9} },
  fontSize = 16,
  onRelease = function()
    mostrarNumerosEmergencia()
    return true
  end
})