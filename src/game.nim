import
  windy,
  boxy,

  extraboxy


var
  player1Score* = 0
  player2Score* = 0


proc drawFps*(window: Window, bxy: Boxy, deltaTime: float) =
  bxy.drawText(
    "FPS",
    translate(vec2(10, 10)),
    "FPS " & $int(1 / deltaTime),
    consolas, 16,
    static parseHex("ffffff"),
    LeftAlign
  )


proc drawScore*(window: Window, bxy: Boxy) =
  bxy.drawText(
    "P1 score",
    translate((window.size.vec2 / 2) + vec2(40, -150)),
    $player1Score,
    consolas, 30,
    static parseHex("ffffff"),
    LeftAlign
  )
  bxy.drawText(
    "P2 score",
    translate((window.size.vec2 / 2) + vec2(-40, -150)),
    $player2Score,
    consolas, 30,
    static parseHex("ffffff"),
    RightAlign
  )
