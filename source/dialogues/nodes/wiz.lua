local wiz = {}

wiz.wiz = {
    text = "Wiz speaks to you.",
    options = {
        {text = "Option 1", next = 'node_1'},
        {text = "Option 2", next = 'node_2'},
        {text = "Option 3", next = 'node_3'},
        {text = "Option 4", next = 'node_4'}
    }
}

-- Define sub-nodes inside this module
wiz.node_1 = {
    text = "This is Sub Node 1",
    options = { {text = "Back", next = "wiz"} }
}

wiz.node_2 = {
    text = "This is Sub Node 2",
    options = { {text = "Back", next = "wiz"} }
}

wiz.node_3 = {
    text = "This is Sub Node 3",
    options = { {text = "Back", next = "wiz"} }
}

wiz.node_4 = {
    text = "This is Sub Node 4",
    options = { {text = "Back", next = "wiz"} }
}

return wiz
