import
  pkg/windy,
  pkg/boxy,

  ../objects


proc init*(_: typedesc[Player], center: Vec2, offsetX: float, keyUp, keyDown: Button): Player =
  Player(
    size: vec2(10, 80),
    pos: vec2(center.x + offsetX, center.y),
    speed: 240'f,
    keyUp: keyUp,
    keyDown: keyDown,
  )


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
