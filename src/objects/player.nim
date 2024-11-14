import pkg/windy
import pkg/boxy
import ../objects

proc init*(_: typedesc[Player], pos: Vec2, keyUp, keyDown: Button): Player =
  Player(
    size: vec2(10, 80),
    pos: pos,
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
  this.pos.y = clamp(this.pos.y, this.size.y / 2, window.size.y.float - this.size.y / 2)

proc update*(this: var Player, window: Window, deltaTime: float) =
  this.move(window, deltaTime)

proc draw*(this: Player, bxy: Boxy, offsetX: float) =
  bxy.saveTransform()
  bxy.translate(this.pos - this.size / 2)
  bxy.drawRect(rect(vec2(offsetX, 0), this.size), color(1, 1, 1, 1))
  bxy.restoreTransform()
