function love.conf(t)
  t.identity = "Constructionist"
  t.version = "11.3"
  t.console = true

  t.window.title = 'Constructionist'
  --t.window.icon = nil
  t.window.width = 1080
  t.window.height = 768
  t.window.resizable = false
  t.window.vsync = false
  t.window.minwidth = 640
  t.window.minheight = 360
  --t.gammacorrect = true
  --t.window.msaa = 4
  t.modules.joystick = false
  t.modules.video = false

end
