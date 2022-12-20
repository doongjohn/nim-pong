import
  windy,
  boxy,
  extraboxy


type
  Player* = object
    size*: Vec2
    pos*: Vec2
    speed*: float
    keyUp*: Button
    keyDown*: Button

  Ball* = object
    size*: Vec2
    pos*: Vec2
    minSpeed*: float
    maxSpeed*: float
    accel*: float
    speed*: float
    dir*: Vec2


var
  player1*: Player
  player2*: Player
  ball*: Ball

  player1Score* = 0
  player2Score* = 0


proc drawScore*(window: Window, bxy: Boxy) =
  bxy.drawText(
    "P1 score",
    translate((window.size.vec2 / 2) + vec2(30, -150)),
    $player1Score,
    consolas,
    30,
    static parseHex("ffffff"),
    LeftAlign
  )
  bxy.drawText(
    "P2 score",
    translate((window.size.vec2 / 2) + vec2(-30, -150)),
    $player2Score,
    consolas,
    30,
    static parseHex("ffffff"),
    RightAlign
  )


import
  objects/player,
  objects/ball as ballmodule


export
  player,
  ballmodule
