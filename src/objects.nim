import
  windy,
  boxy,
  extramath


type
  Player* = object
    size*: Vec2
    pos*: Vec2
    speed*: float
    keyUp: Button
    keyDown: Button

  Ball* = object
    size*: Vec2
    pos*: Vec2
    defaultSpeed*: float
    accel*: float
    speed*: float
    dir*: Vec2


var
  player1*: Player
  player2*: Player
  ball*: Ball


proc init*(_: typedesc[Player], center: Vec2, offsetX: float, keyUp, keyDown: Button): Player =
  result = Player()
  result.size = vec2(10, 80)
  result.pos = vec2(center.x + offsetX, center.y)
  result.speed = 200'f
  result.keyUp = keyUp
  result.keyDown = keyDown


proc move(this: var Player, window: Window, deltaTime: float) =
  if window.buttonDown[this.keyUp]:
    this.pos.y -= this.speed * deltaTime
  if window.buttonDown[this.keyDown]:
    this.pos.y += this.speed * deltaTime

  # clamp position
  this.pos.y = clamp(this.pos.y, this.size.y / 2, window.size.vec2.y - this.size.y / 2)


proc update*(this: var Player, window: Window, deltaTime: float) =
  this.move(window, deltaTime)


proc draw*(this: Player, bxy: Boxy, offsetX: float) =
  bxy.saveTransform()
  bxy.translate(this.pos)
  bxy.translate(-this.size / 2)
  bxy.drawRect(rect(vec2(offsetX, 0), this.size), color(1, 1, 1, 1))
  bxy.restoreTransform()


proc init*(_: typedesc[Ball], pos: Vec2, dir: Vec2): Ball =
  result = Ball()
  result.size = vec2(10, 10)
  result.pos = pos
  result.defaultSpeed = 200'f
  result.accel = 20'f
  result.speed = 200'f
  result.dir = dir.normalize()


proc playerCollision(this: var Ball, deltaTime: float) =
  func checkYOverlap(this: Ball, player: Player): bool =
    let top = this.pos.y - this.size.y / 2
    let bot = this.pos.y + this.size.y / 2
    result =
      (top >= player.pos.y - player.size.y / 2 and top <= player.pos.y + player.size.y / 2) or
      (bot >= player.pos.y - player.size.y / 2 and bot <= player.pos.y + player.size.y / 2)

  let nextX = this.pos.x + this.dir.x * this.speed * deltaTime
  let isOverlapXPlayer1 = this.pos.x + this.size.x / 2 <= player1.pos.x and nextX + this.size.x / 2 >= player1.pos.x
  let isOverlapXPlayer2 = this.pos.x - this.size.x / 2 >= player2.pos.x and nextX - this.size.x / 2 <= player2.pos.x

  if this.dir.x > 0 and isOverlapXPlayer1:
    if checkYOverlap(this, player1):
      this.speed = this.defaultSpeed
      this.dir = (this.pos - player1.pos).normalize()
      # clamp position
      this.pos.x = player1.pos.x - this.size.x / 2

  if this.dir.x < 0 and isOverlapXPlayer2:
    if checkYOverlap(this, player2):
      this.speed = this.defaultSpeed
      this.dir = (this.pos - player2.pos).normalize()
      # clamp position
      this.pos.x = player2.pos.x + this.size.x / 2


proc move(this: var Ball, window: Window, deltaTime: float) =
  this.pos += this.dir * (this.speed * deltaTime)

  if this.pos.y < this.size.y / 2:
    this.speed += this.accel
    this.dir = this.dir.reflect(vec2(0, -1))

  if this.pos.y > window.size.vec2.y - this.size.y / 2:
    this.speed += this.accel
    this.dir = this.dir.reflect(vec2(0, 1))

  if this.pos.x < this.size.x / 2:
    # TODO: update score
    this.dir = this.dir.reflect(vec2(1, 0))

  if this.pos.x > window.size.vec2.x - this.size.x / 2:
    # TODO: update score
    this.dir = this.dir.reflect(vec2(-1, 0))

  # clamp position
  this.pos.x = clamp(this.pos.x, this.size.x / 2, window.size.vec2.x - this.size.x / 2)
  this.pos.y = clamp(this.pos.y, this.size.y / 2, window.size.vec2.y - this.size.y / 2)


proc update*(this: var Ball, window: Window, deltaTime: float) =
  this.playerCollision(deltaTime)
  this.move(window, deltaTime)


proc draw*(this: Ball, bxy: Boxy) =
  bxy.saveTransform()
  bxy.translate(this.pos)
  bxy.translate(-this.size / 2)
  bxy.drawRect(rect(vec2(0, 0), this.size), color(1, 1, 1, 1))
  bxy.restoreTransform()
