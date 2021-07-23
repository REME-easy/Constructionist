local tmp = {
  name_id = "tutorial2",
  blocks = {
    player = {type = "mover", sym = "P"},
    robot = {child = 2, type = "robot", sym = "R"},
    flag = {type = "collide_flag", sym = "F"},
    wall = {type = "wall", sym = "W"},
    entrance = {type = "entrance", sym = "E"}
  },
  maps = {
    {
      map = {
        "__W_R__P",
        "__W_WWWW",
        "________",
        "________"
      }
    },
    {
      map = {
        "WWWW",
        "___E",
        "____"
      }
    }
  }
}
return tmp
