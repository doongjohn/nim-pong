import
  pkg/windy,
  pkg/boxy


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


import
  objects/player,
  objects/ball as ballmodule


export
  player,
  ballmodule
