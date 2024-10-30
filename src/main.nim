import std/times
import std/monotimes
import pkg/opengl
import pkg/windy
import pkg/boxy
import game
import objects

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

  # init opengl
  window.makeContextCurrent()
  loadExtensions()

  let bxy = newBoxy()

  template center: auto = window.size.vec2 / 2

  # init objects
  player1 = Player.init(center, 280, KeyUp, KeyDown)
  player2 = Player.init(center, -280, KeyW, KeyS)
  ball = Ball.init(center, vec2(-1, 0))

  var frameStartTime = getMonoTime()
  var deltaTime: float

  template update(body: untyped): untyped =
    let currentTime = getMonoTime()
    deltaTime = (currentTime - frameStartTime).inMilliseconds.float / 1000.0
    frameStartTime = currentTime
    body

  template render(body: untyped): untyped =
    bxy.beginFrame(window.size)
    bxy.drawRect(rect(vec2(0, 0), window.size.vec2), static parseHex("9038fc"))
    body
    bxy.endFrame()
    window.swapBuffers()

  while not window.closeRequested():
    pollEvents()

    update:
      # press escape to exit
      if window.buttonDown[KeyEscape]:
        window.closeRequested = true

      # update objects
      player1.update(window, deltaTime)
      player2.update(window, deltaTime)
      ball.update(window, deltaTime)

    render:
      # draw objects
      player1.draw(bxy, player1.size.x / 2)
      player2.draw(bxy, -player2.size.x / 2)
      ball.draw(bxy)

      # draw UI
      drawScore(window, bxy)
      drawFps(window, bxy, deltaTime)

main()
