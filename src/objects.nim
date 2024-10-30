import pkg/windy
import pkg/boxy

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

# not needed if using experimental:typeBoundOps
import objects/player
import objects/ball as ballmodule
export player
export ballmodule
