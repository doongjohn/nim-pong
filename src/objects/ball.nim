import
  windy,
  boxy,

  ../game,
  ../extramath,
  ../objects


proc init*(_: typedesc[Ball], pos: Vec2, dir: Vec2): Ball =
  result = Ball()
  result.size = vec2(10, 10)
  result.pos = pos
  result.minSpeed = 250'f
  result.maxSpeed = 420'f
  result.accel = 20'f
  result.speed = 200'f
  result.dir = dir.normalize()


proc playerCollision(this: var Ball, deltaTime: float) =
  let top = this.pos.y - this.size.y / 2
  let bot = this.pos.y + this.size.y / 2

  template checkYOverlap(this: Ball, player: Player): bool =
    (top >= player.pos.y - player.size.y / 2 and top <= player.pos.y + player.size.y / 2) or
    (bot >= player.pos.y - player.size.y / 2 and bot <= player.pos.y + player.size.y / 2)

  let nextX = this.pos.x + this.dir.x * this.speed * deltaTime
  let isOverlapXPlayer1 = this.pos.x + this.size.x / 2 <= player1.pos.x and nextX + this.size.x / 2 >= player1.pos.x
  let isOverlapXPlayer2 = this.pos.x - this.size.x / 2 >= player2.pos.x and nextX - this.size.x / 2 <= player2.pos.x

  if this.dir.x > 0 and isOverlapXPlayer1:
    if checkYOverlap(this, player1):
      this.speed = min(this.speed + this.accel, this.maxSpeed)
      this.dir = (this.pos - player1.pos).normalize()
      this.pos.x = player1.pos.x - this.size.x / 2

  if this.dir.x < 0 and isOverlapXPlayer2:
    if checkYOverlap(this, player2):
      this.speed = min(this.speed + this.accel, this.maxSpeed)
      this.dir = (this.pos - player2.pos).normalize()
      this.pos.x = player2.pos.x + this.size.x / 2


proc move(this: var Ball, window: Window, deltaTime: float) =
  # update position
  this.pos += this.dir * (this.speed * deltaTime)

  # hit top wall
  if this.pos.y < this.size.y / 2:
    this.speed = min(this.speed + this.accel, this.maxSpeed)
    this.dir = this.dir.reflect(vec2(0, -1))

  # hit bottom wall
  if this.pos.y > window.size.vec2.y - this.size.y / 2:
    this.speed = min(this.speed + this.accel, this.maxSpeed)
    this.dir = this.dir.reflect(vec2(0, 1))

  # hit left wall
  if this.pos.x < this.size.x / 2:
    inc player1Score
    this.speed = this.minSpeed
    this.dir = this.dir.reflect(vec2(1, 0))

  # hit right wall
  if this.pos.x > window.size.vec2.x - this.size.x / 2:
    inc player2Score
    this.speed = this.minSpeed
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
