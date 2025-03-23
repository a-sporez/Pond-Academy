local olive = {}
-- olive's premise is about good apples
olive.olive = {
    text = "OH SHIT OH FUCK!! WHY IS MY FACE ALL FUCKED LIKE THAT?!^",
    options = {
        {text = "I don't know! Who are you?", next = 'node_1'},
        {text = "Option 2", next = 'node_2'},
        {text = "Option 3", next = 'node_3'},
        {text = "Option 4", next = 'node_4'}
    }
}

-- Define sub-nodes inside this module
olive.node_1 = {
    text = "Node 1",
    options = {
        {text = "Back", next = "olive"}
    }
}

olive.node_2 = {
    text = "This is Sub Node 2",
    options = {
        {text = "Back", next = "olive"}
    }
}

olive.node_3 = {
    text = "This is Sub Node 3",
    options = {
        {text = "Back", next = "olive"}
    }
}

olive.node_4 = {
    text = "This is Sub Node 4",
    options = {
        {text = "Back", next = "olive"}
    }
}

return olive
