
local critter_2 = {
    text = "Critter 1 Text",
    options = {
        {text = "Sub Node 2-1", next = 'critter_2_1'},
        {text = "Sub Node 2-2", next = 'critter_2_2'},
        {text = "Sub Node 2-3", next = 'critter_2_3'},
        {text = "Sub Node 2-4", next = 'critter_2_4'},
        {text = "Return to Archives", next = 'archives'}
    }
}

-- Define sub-nodes inside this module
critter_2.critter_2_1 = {
    text = "This is Sub Node 2-1",
    options = { {text = "Back", next = "critter_2"} }
}

critter_2.critter_2_2 = {
    text = "This is Sub Node 2-2",
    options = { {text = "Back", next = "critter_2"} }
}

critter_2.critter_2_3 = {
    text = "This is Sub Node 2-3",
    options = { {text = "Back", next = "critter_2"} }
}

critter_2.critter_2_4 = {
    text = "This is Sub Node 2-4",
    options = { {text = "Back", next = "critter_2"} }
}

return critter_2
