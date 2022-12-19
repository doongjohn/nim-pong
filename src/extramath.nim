import vmath


func reflect*(vec, normal: Vec2): Vec2 =
  vec - 2 * (vec.dot normal) * normal
