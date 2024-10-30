import pkg/boxy

let consolas* = readTypeface("C:\\Windows\\Fonts\\consola.ttf")

proc drawText*(
  bxy: Boxy,
  imageKey: string,
  transform: Mat3,
  text: string,
  typeface: Typeface,
  size: float32,
  color: Color,
  hAlign: HorizontalAlignment,
) =
  var font = newFont(typeface)
  font.size = size
  font.paint = color

  let
    arrangement = typeset(@[newSpan(text, font)], hAlign = hAlign)
    globalBounds = arrangement.computeBounds(transform).snapToPixels()
    textImage = newImage(globalBounds.w.int, globalBounds.h.int)
    imageSpace = translate(-globalBounds.xy) * transform
  textImage.fillText(arrangement, imageSpace)

  bxy.addImage(imageKey, textImage)
  bxy.drawImage(imageKey, globalBounds.xy)
