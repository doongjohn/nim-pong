import std/times
import std/monotimes
import pkg/opengl
import pkg/windy
import pkg/boxy
import game
import objects

type App = object
  window: Window
  bxy: Boxy

  fixedDeltaTime = 0.01
  deltaTime = 0.0
  accumulator = 0.0
  elapsedTime = 0.0
  frameStartTime: MonoTime

proc initApp(): App =
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

proc main() =
  var app = initApp()

  template center: auto = app.window.size.vec2 / 2

  # init objects
  player1 = Player.init(center, 280, KeyUp, KeyDown)
  player2 = Player.init(center, -280, KeyW, KeyS)
  ball = Ball.init(center, vec2(-1, 0))

  var fpsTimer = 0.0
  var fpsValue = 0.0
  var fpsCount = 0

  template fixedUpdate(body: untyped): untyped =
    let currentTime = getMonoTime()
    app.deltaTime = (currentTime - app.frameStartTime).inMicroseconds.float / 1000000.0
    app.frameStartTime = currentTime

    let frameTime = if app.deltaTime > 0.25: 0.25 else: app.deltaTime
    app.accumulator += frameTime

    while app.accumulator >= app.fixedDeltaTime:
      app.elapsedTime += app.fixedDeltaTime
      app.accumulator -= app.fixedDeltaTime
      body

  template render(body: untyped): untyped =
    app.bxy.beginFrame(app.window.size)
    app.bxy.drawRect(rect(vec2(0, 0), app.window.size.vec2), static parseHex("9038fc"))
    body
    app.bxy.endFrame()
    app.window.swapBuffers()

  app.frameStartTime = getMonoTime()
  while not app.window.closeRequested():
    pollEvents()

    fixedUpdate:
      # press escape to exit
      if app.window.buttonDown[KeyEscape]:
        app.window.closeRequested = true

      # update objects
      player1.update(app.window, app.fixedDeltaTime)
      player2.update(app.window, app.fixedDeltaTime)
      ball.update(app.window, app.fixedDeltaTime)

    render:
      # draw objects
      player1.draw(app.bxy, player1.size.x / 2)
      player2.draw(app.bxy, -player2.size.x / 2)
      ball.draw(app.bxy)

      # draw UI
      drawScore(app.window, app.bxy)

      # draw FPS
      fpsTimer += app.deltaTime
      fpsCount += 1
      if fpsTimer >= 0.5:
        fpsValue = fpsTimer / fpsCount.float
        fpsTimer = 0
        fpsCount = 0
      drawFps(app.window, app.bxy, fpsValue)

main()
