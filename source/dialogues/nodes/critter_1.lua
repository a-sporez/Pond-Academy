local critter_1 = {
    text = "Critter 1 Text",
    options = {
        {text = "Sub Node 1-1", next = 'critter_1_1'},
        {text = "Sub Node 1-2", next = 'critter_1_2'},
        {text = "Sub Node 1-3", next = 'critter_1_3'},
        {text = "Sub Node 1-4", next = 'critter_1_4'},
        {text = "Return to Archives", next = 'archives'}
    }
}

-- Define sub-nodes inside this module
critter_1.critter_1_1 = {
    text = "This is Sub Node 1-1",
    options = { {text = "Back", next = "critter_1"} }
}

critter_1.critter_1_2 = {
    text = "This is Sub Node 1-2",
    options = { {text = "Back", next = "critter_1"} }
}

critter_1.critter_1_3 = {
    text = "This is Sub Node 1-3",
    options = { {text = "Back", next = "critter_1"} }
}

critter_1.critter_1_4 = {
    text = "This is Sub Node 1-4",
    options = { {text = "Back", next = "critter_1"} }
}

return critter_1