local bambi = {}
-- Bambi's premise is about the thrill of first times, first moments, the adventure time.
bambi.bambi = {
    text = "Heya Bunny! What's up with you? What are you doing?",
    options = {
        {text = "I'm not a bunny! I'm a hare.", next = 'node_1'},
        {text = "What is this place?", next = 'node_2'},
        {text = "Option 3", next = 'node_3'},
        {text = "Option 4", next = 'node_4'}
    }
}

-- Define sub-nodes inside this module
bambi.node_1 = {
    text = "Whooa okay, didn't mean to contradict you little rabbit.",
    options = {
        {text = "I'm not a rabbit! I'm a hare.", next = 'node_1b'},
        {text = "Back", next = "bambi"}
    }
}

bambi.node_1b = {
    text = "Well you definitely seem certain of yourself now!",
    options = {
        {text = "I am not... Who are you?", next = 'node_1c'},
        {text = "back", next = 'bambi'}
    }
}

bambi.node_1c = {
    text = "I am Bootle Big Bambitee... wait no, I am Bamboot Bigle Beet... wat!? Sorry, my name is BeetleBootb... WHAT THE FUCK!?",
    options = {
        {text = "Uhm, are you OK?", next = 'node_1d'},
        {text = "back", next = 'bambi'}
    }
}

bambi.node_1d = {
    text = "...",
    options = { -- BOOKMARK
        {text = "back", next = 'bambi'}
    }
}

bambi.node_2 = {
    text = "This is the Pondsc... well, things are different now. Hmm I guess it's called the Archives now for some reason.",
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
