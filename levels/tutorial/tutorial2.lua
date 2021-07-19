local tmp = {
  name_id = "tutorial2",
  blocks = {
    player = {type = "mover", sym = "P"},
    flag = {type = "collide_flag", sym = "F"},
    box = {type = "box", sym = "B"}
  },
  maps = {
    {
      map = {
        "_B_B_B",
        "B_B_B_",
        "_B_B_B",
        "B_B_B_",
        "PB_B_F"
      }
    }
  }
}
return tmp
