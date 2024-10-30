import pkg/windy
import pkg/boxy
import ../game
import ../extramath
import ../objects

proc init*(_: typedesc[Ball], pos: Vec2, dir: Vec2): Ball =
  Ball(
    size: vec2(10, 10),
    pos: pos,
    minSpeed: 250'f,
    maxSpeed: 420'f,
    accel: 20'f,
    speed: 200'f,
    dir: dir.normalize(),
  )

func getNextPos(this: var Ball, deltaTime: float): Vec2 =
  vec2(
    this.pos.x + this.dir.x * min(this.speed, this.maxSpeed) * deltaTime,
    this.pos.y + this.dir.y * min(this.speed, this.maxSpeed) * deltaTime
  )

proc collisionWithWall(this: var Ball, window: Window, deltaTime: float) =
  let nextPos = this.getNextPos(deltaTime)

  # hit top wall
  if nextPos.y < this.size.y / 2:
    this.speed = this.speed + this.accel
    this.dir = this.dir.reflect(vec2(0, -1))

  # hit bottom wall
  if nextPos.y > window.size.y.float - this.size.y / 2:
    this.speed = this.speed + this.accel
    this.dir = this.dir.reflect(vec2(0, 1))

  # hit left wall
  if nextPos.x < this.size.x / 2:
    inc player1Score
    this.speed = this.minSpeed
    this.dir = this.dir.reflect(vec2(1, 0))

  # hit right wall
  if nextPos.x > window.size.x.float - this.size.x / 2:
    inc player2Score
    this.speed = this.minSpeed
    this.dir = this.dir.reflect(vec2(-1, 0))

proc collisionWithPlayer(this: var Ball, deltaTime: float) =
  let nextPos = this.getNextPos(deltaTime)
  let top = this.pos.y - this.size.y / 2
  let bot = this.pos.y + this.size.y / 2

  template isCollidingWith(player: var Player): bool =
    let playerTop = player.pos.y - player.size.y / 2
    let playerBot = player.pos.y + player.size.y / 2
    let collidingY =
      (top >= playerTop and top <= playerBot) or
      (bot >= playerTop and bot <= playerBot)
    let collidingX =
      (this.dir.x > 0 and this.pos.x <= player.pos.x and nextPos.x + this.size.x / 2 >= player.pos.x) or
      (this.dir.x < 0 and this.pos.x >= player.pos.x and nextPos.x - this.size.x / 2 <= player.pos.x)
    collidingY and collidingX

  if this.dir.x > 0 and isCollidingWith(player1):
    this.speed = this.speed + this.accel
    this.dir = (this.pos - player1.pos).normalize()
    this.pos.x = player1.pos.x - this.size.x / 2

  if this.dir.x < 0 and isCollidingWith(player2):
    this.speed = this.speed + this.accel
    this.dir = (this.pos - player2.pos).normalize()
    this.pos.x = player2.pos.x + this.size.x / 2

proc move(this: var Ball, window: Window, deltaTime: float) =
  # clamp speed
  this.speed = min(this.speed, this.maxSpeed)

  # update position
  this.pos += this.dir * (this.speed * deltaTime)

  # clamp position
  this.pos.x = clamp(this.pos.x, this.size.x / 2, window.size.x.float - this.size.x / 2)
  this.pos.y = clamp(this.pos.y, this.size.y / 2, window.size.y.float - this.size.y / 2)

proc update*(this: var Ball, window: Window, deltaTime: float) =
  this.collisionWithWall(window, deltaTime)
  this.collisionWithPlayer(deltaTime)
  this.move(window, deltaTime)

proc draw*(this: Ball, bxy: Boxy) =
  bxy.saveTransform()
  bxy.translate(this.pos - this.size / 2)
  bxy.drawRect(rect(vec2(0, 0), this.size), color(1, 1, 1, 1))
  bxy.restoreTransform()
