import std/times
import std/monotimes
import pkg/opengl
import pkg/windy
import pkg/boxy

const fixedDeltaTime*: float = 0.01

type App* = object
  window*: Window
  bxy*: Boxy
  frameStartTime*: MonoTime
  timeDiff*: Duration
  deltaTime*: float
  accumulator*: float
  elapsedTime*: float

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

template center*(window: Window): Vec2 =
  window.size.vec2 / 2

template calculateDeltaTime*(app: var App) =
  let currentTime = getMonoTime()
  app.timeDiff += currentTime - app.frameStartTime
  app.frameStartTime = currentTime

  app.deltaTime = app.timeDiff.inMicroseconds.float / 1000000.0
  if app.deltaTime > 0: app.timeDiff = Duration()

  let frameTime = if app.deltaTime > 0.25: 0.25 else: app.deltaTime
  app.accumulator += frameTime

template gameLoop*(app: var App, body: untyped): untyped =
  app.frameStartTime = getMonoTime()
  while not app.window.closeRequested():
    pollEvents()
    app.calculateDeltaTime()
    body

template fixedUpdate*(app: var App, body: untyped): untyped =
  while app.accumulator >= fixedDeltaTime:
    app.elapsedTime += fixedDeltaTime
    app.accumulator -= fixedDeltaTime
    body

template render*(app: var App, body: untyped): untyped =
  app.bxy.beginFrame(app.window.size)
  app.bxy.drawRect(rect(vec2(0, 0), app.window.size.vec2), static parseHex("9038fc"))
  body
  app.bxy.endFrame()
  app.window.swapBuffers()
