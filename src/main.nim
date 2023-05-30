import
  std/times,
  std/monotimes,

  # packages
  opengl,
  windy,
  boxy,

  # modules
  game,
  objects


proc main() =
  # create a window
  let window = newWindow(
    title = "Pong",
    size = ivec2(640, 360),
    vsync = true,
    msaa = msaa4x,
  )

  # disable window resize
  window.style = Decorated

  makeContextCurrent(window)
  loadExtensions()

  let bxy = newBoxy()
  let center = window.size.vec2 / 2

  player1 = Player.init(center, 280, KeyUp, KeyDown)
  player2 = Player.init(center, -280, KeyW, KeyS)
  ball = Ball.init(center, vec2(-1, 0))

  var frameStartTime = getMonoTime()
  var deltaTime: float

  window.onFrame = proc() =
    # calculate delta time
    let currentTime = getMonoTime()
    deltaTime = (currentTime - frameStartTime).inMilliseconds.float / 1000'f
    frameStartTime = currentTime

    # clear screen
    bxy.beginFrame(window.size)
    bxy.drawRect(rect(vec2(0, 0), window.size.vec2), static parseHex("9038fc"))

    # update objects
    player1.update(window, deltaTime)
    player2.update(window, deltaTime)
    ball.update(window, deltaTime)

    # draw objects
    player1.draw(bxy, player1.size.x / 2)
    player2.draw(bxy, -player2.size.x / 2)
    ball.draw(bxy)

    # draw score text
    drawScore(window, bxy)
    drawFps(window, bxy, deltaTime)

    bxy.endFrame()
    window.swapBuffers()

  # start event loop
  while not window.closeRequested:
    pollEvents()


main()
