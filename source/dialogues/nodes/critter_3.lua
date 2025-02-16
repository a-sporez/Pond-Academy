
local critter_3 = {
    text = "Critter 1 Text",
    options = {
        {text = "Sub Node 3-1", next = 'critter_3_1'},
        {text = "Sub Node 3-2", next = 'critter_3_2'},
        {text = "Sub Node 3-3", next = 'critter_3_3'},
        {text = "Sub Node 3-4", next = 'critter_3_4'},
        {text = "Return to Archives", next = 'archives'}
    }
}

critter_3.critter_3_1 = {
    text = "This is Sub Node 3-1",
    options = { {text = "back", next = "critter_3"} }
}

critter_3.critter_3_2 = {
    text = "This is Sub Node 3-2",
    options = { {text = "back", next = "critter_3"} }
}

critter_3.critter_3_3 = {
    text = "This is Sub Node 3-3",
    options = { {text = "back", next = "critter_3"} }
}

critter_3.critter_3_4 = {
    text = "This is Sub Node 3-4",
    options = { {text = "back", next = "critter_3"} }
}

return critter_3
