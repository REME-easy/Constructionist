local tmp = {
  name_id = "test1",
  blocks = {
    player = {child = 2, type = "mover", sym = "P"},
    block1 = {child = 3, type = "box", sym = "A"},
    wall = {type = "wall", sym = "W"}
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
    },
    {
      map = {
        "___",
        "___",
        "___"
      }
    },
    {
      map = {
        "_________",
        "_________",
        "_________"
      }
    }
  }
}
return tmp
