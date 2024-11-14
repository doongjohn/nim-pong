import pkg/windy
import pkg/boxy
import app
import game
import objects

proc main() =
  var app = initApp()
  var fpsTimer = 0.0
  var fpsValue = 0.0
  var fpsCount = 0

  # init objects
  player1 = Player.init(app.window.center + vec2(280, 0), KeyUp, KeyDown)
  player2 = Player.init(app.window.center - vec2(280, 0), KeyW, KeyS)
  ball = Ball.init(app.window.center, vec2(-1, 0))

  app.gameLoop:
    app.fixedUpdate:
      # press escape to exit
      if app.window.buttonDown[KeyEscape]:
        app.window.closeRequested = true

      # update objects
      player1.update(app.window, app.fixedDeltaTime)
      player2.update(app.window, app.fixedDeltaTime)
      ball.update(app.window, app.fixedDeltaTime)

    app.render:
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
