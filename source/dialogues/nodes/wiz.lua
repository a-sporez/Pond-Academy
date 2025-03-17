local wiz = {}
-- wiz premise is caution, the danger within, the game.
wiz.wiz = {
    text = "Wiz.",
    options = {
        {text = "Wiz", next = 'node_1'},
        {text = "Wiz", next = 'node_2'},
        {text = "Wiz", next = 'node_3'},
        {text = "Wiz", next = 'node_4'}
    }
}

-- Define sub-nodes inside this module
wiz.node_1 = {
    text = "Wiz",
    options = { {text = "Wiz", next = "wiz"} }
}

wiz.node_2 = {
    text = "Wiz",
    options = { {text = "Wiz", next = "wiz"} }
}

wiz.node_3 = {
    text = "Wiz",
    options = { {text = "Wiz", next = "wiz"} }
}

wiz.node_4 = {
    text = "Wiz",
    options = { {text = "Wiz", next = "wiz"} }
}

return wiz
