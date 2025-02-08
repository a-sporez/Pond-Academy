
local critter_2 = {
    text = "Critter 2 Text",
    options = {
        {text = "Sub Node 2-1", next = 'critter_2_1'},
        {text = "Sub Node 2-2", next = 'critter_2_2'},
        {text = "Sub Node 2-3", next = 'critter_2_3'},
        {text = "Sub Node 2-4", next = 'critter_2_4'},
        {text = "Return to Archives", next = 'archives'}
    }
}

return critter_2
