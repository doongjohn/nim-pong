import pkg/windy
import pkg/boxy
import app
import game
import objects

proc main() =
  var a = initApp()
  var fpsTimer = 0.0
  var fpsValue = 0.0
  var fpsCount = 0

  # init objects
  player1 = Player.init(a.window.center + vec2(280, 0), KeyUp, KeyDown)
  player2 = Player.init(a.window.center - vec2(280, 0), KeyW, KeyS)
  ball = Ball.init(a.window.center, vec2(-1, 0))

  a.gameLoop:
    # press escape to exit
    if a.window.buttonDown[KeyEscape]:
      a.window.closeRequested = true

    a.fixedUpdate:
      player1.update(a.window, app.fixedDeltaTime)
      player2.update(a.window, app.fixedDeltaTime)
      ball.update(a.window, app.fixedDeltaTime)

    a.render:
      # draw objects
      player1.draw(a.bxy, player1.size.x / 2)
      player2.draw(a.bxy, -player2.size.x / 2)
      ball.draw(a.bxy)

      # draw UI
      drawScore(a.window, a.bxy)

      # draw FPS
      fpsTimer += a.deltaTime
      fpsCount += 1
      if fpsTimer >= 0.5:
        fpsValue = fpsTimer / fpsCount.float
        fpsTimer = 0
        fpsCount = 0
      drawFps(a.window, a.bxy, fpsValue)

main()
