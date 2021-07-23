local tmp = {
  name_id = "test1",
  blocks = {
    player = {type = "mover", sym = "P"},
    block1 = {type = "box", sym = "A"},
    wall = {type = "wall", sym = "W"},
    entrance = {type = "entrance", sym = "E"},
    energy_cube = {type = "energy_cube", sym = "C"}
  },
  maps = {
    {
      map = {
        "P________W",
        "__W_AAA__W",
        "_WW______W",
        "__C______W",
        "_________W"
      }
    }
  }
}
return tmp
