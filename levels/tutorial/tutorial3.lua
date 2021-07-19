local tmp = {
  name_id = "tutorial2",
  blocks = {
    player = {type = "mover", sym = "P"},
    robot = {child = 2, type = "robot", sym = "R"},
    flag = {type = "collide_flag", sym = "F"},
    wall = {type = "wall", sym = "W"}
  },
  maps = {
    {
      map = {
        "__________",
        "_____W____",
        "WWWW_W_WWW",
        "F____W___R"
      }
    },
    {
      map = {
        "W_WW",
        "WP__",
        "___W",
        "WW_W"
      }
    }
  }
}
return tmp
