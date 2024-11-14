import std/times
import std/monotimes
import pkg/opengl
import pkg/windy
import pkg/boxy

type App* = object
  window*: Window
  bxy*: Boxy

  fixedDeltaTime* = 0.01
  deltaTime* = 0.0
  accumulator* = 0.0
  elapsedTime* = 0.0
  frameStartTime*: MonoTime
  timeDiff*: Duration

proc initApp*(): App =
  # create a window
  let window = newWindow(
    title = "Pong",
    size = ivec2(640, 360),
    vsync = false,
    msaa = msaa4x,
  )

  # disable window resize
  window.style = Decorated

  # init opengl
  window.makeContextCurrent()
  loadExtensions()

  return App(window: window, bxy: newBoxy())

template center*(window: Window): auto =
  window.size.vec2 / 2

template calculateDeltaTime*(app: App) =
  let currentTime = getMonoTime()
  app.timeDiff += currentTime - app.frameStartTime
  app.frameStartTime = currentTime

  app.deltaTime = app.timeDiff.inMicroseconds.float / 1000000.0
  if app.deltaTime > 0: app.timeDiff = Duration()

  let frameTime = if app.deltaTime > 0.25: 0.25 else: app.deltaTime
  app.accumulator += frameTime

template gameLoop*(app: App, body: untyped): untyped =
  app.frameStartTime = getMonoTime()
  while not app.window.closeRequested():
    pollEvents()
    app.calculateDeltaTime()
    body

template fixedUpdate*(app: App, body: untyped): untyped =
  while app.accumulator >= app.fixedDeltaTime:
    app.elapsedTime += app.fixedDeltaTime
    app.accumulator -= app.fixedDeltaTime
    body

template render*(app: App, body: untyped): untyped =
  app.bxy.beginFrame(app.window.size)
  app.bxy.drawRect(rect(vec2(0, 0), app.window.size.vec2), static parseHex("9038fc"))
  body
  app.bxy.endFrame()
  app.window.swapBuffers()
