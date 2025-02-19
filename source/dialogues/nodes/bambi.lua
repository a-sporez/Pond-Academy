local bambi = {}

bambi.bambi = {
    text = "Bambi speaks to you.",
    options = {
        {text = "Option 1", next = 'node_1'},
        {text = "Option 2", next = 'node_2'},
        {text = "Option 3", next = 'node_3'},
        {text = "Option 4", next = 'node_4'}
    }
}

-- Define sub-nodes inside this module
bambi.node_1 = {
    text = "This is Sub Node 1",
    options = { {text = "Back", next = "bambi"} }
}

bambi.node_2 = {
    text = "This is Sub Node 2",
    options = { {text = "Back", next = "bambi"} }
}

bambi.node_3 = {
    text = "This is Sub Node 3",
    options = { {text = "Back", next = "bambi"} }
}

bambi.node_4 = {
    text = "This is Sub Node 4",
    options = { {text = "Back", next = "bambi"} }
}

return bambi
