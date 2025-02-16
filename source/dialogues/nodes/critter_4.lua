
local critter_4 = {
    text = "Critter 1 Text",
    options = {
        {text = "Sub Node 4-1", next = 'critter_4_1'},
        {text = "Sub Node 4-2", next = 'critter_4_2'},
        {text = "Sub Node 4-3", next = 'critter_4_3'},
        {text = "Sub Node 4-4", next = 'critter_4_4'},
        {text = "Return to Archives", next = 'archives'}
    }
}

critter_4.critter_4_1 = {
    text = "This is Sub Node 3-1",
    options = { {text = "back", next = "critter_3"} }
}

critter_4.critter_4_2 = {
    text = "This is Sub Node 3-2",
    options = { {text = "back", next = "critter_3"} }
}

critter_4.critter_4_3 = {
    text = "This is Sub Node 3-3",
    options = { {text = "back", next = "critter_3"} }
}

critter_4.critter_4_4 = {
    text = "This is Sub Node 3-4",
    options = { {text = "back", next = "critter_3"} }
}

return critter_4
