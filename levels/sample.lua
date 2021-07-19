local tmp = {
  name_id = "tutorial1",
  blocks = {
    player = {child = 2, type = "mover", sym = "P"},
    flag = {type = "collide_flag", sym = "F"}
  },
  maps = {
    {
      map = {
        "P________W",
        "__W_A____W",
        "_WW______W",
        "_________W",
        "_________W"
      }
    }
  }
}
return tmp
