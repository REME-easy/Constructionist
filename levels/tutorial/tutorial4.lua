local tmp = {
  name_id = "tutorial2",
  blocks = {
    player = {type = "mover", sym = "P"},
    robot = {child = 2, type = "robot", sym = "R"},
    flag = {type = "collide_flag", sym = "F"},
    wall = {type = "wall", sym = "W"},
    box = {type = "box", sym = "B"}
  },
  maps = {
    {
      map = {
        "_W______WR",
        "_W___W__W_",
        "_W___W__W_",
        "F____W____"
      }
    },
    {
      map = {
        "W_WWW",
        "W_BP_",
        "W_PB_",
        "___B_",
        "WWW_W"
      }
    }
  }
}
return tmp
