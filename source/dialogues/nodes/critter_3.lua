
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

return critter_3
