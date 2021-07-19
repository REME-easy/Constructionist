local tmp = {
  name_id = "tutorial1",
  blocks = {
    player = {type = "mover", sym = "P"},
    flag = {type = "collide_flag", sym = "F"},
    wall = {type = "wall", sym = "W"}
  },
  maps = {
    {
      map = {
        "WWWWWWWWWW",
        "W________W",
        "W_P____F_W",
        "W________W",
        "WWWWWWWWWW"
      }
    }
  }
}
return tmp
