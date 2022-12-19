# Package

version       = "0.1.0"
author        = "doongjohn"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
namedBin["main"] = "pong"


# Dependencies

requires "nim >= 1.7.3"
requires "boxy"
requires "windy"

task debug, "build debug":
  exec "nim c -d:mingw --out:pong src/main.nim"

task release, "build release":
  exec "nim c -d:mingw --app:gui -d:release --opt:size --out:pong src/main.nim"
