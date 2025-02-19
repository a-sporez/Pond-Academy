local smug = {}

smug.smug = {
    text = "WWOOOOAAAHH!? What the fuck are you doing here!? What do you want from me!?",
    options = {
        {text = "Smug!? What happened!?", next = 'node_1'},
        {text = "What is this place!?", next = 'node_2'},
        {text = "I... can't remember my name, who... what am I?", next = 'node_3'},
        {text = "Can you tell me about psychic warfare?", next = 'node_4'}
    }
}

smug.node_1 = {
    text = "My name is SmugBUG! I have no idea who that smug person is but I hate them. You should ask them what happened. Now leave me alone!",
    options = { {text = "Back", next = "smug"} }
}

smug.node_2 = {
    text = "What do YOU MEAN!? YOU think that I KNOW what the fuck this place is?!? I mean, look at me! I don't even have limbs, is this a joke? Get me the FUCK out of here! AAAAAAAHRRG!!",
    options = { {text = "Back", next = "smug"} }
}

smug.node_3 = {
    text = "Bwaahahhahaha get wreckt!! It's pretty obvious that you are some kind of angry bunny but really... deep down? Do you even know?",
    options = { {text = "Back", next = "smug"} }
}

smug.node_4 = {
    text = "Yes I have written 4 doctorate theses on psychic warfare and separated the field into two levels. What do you want to know?",
    options = {
        {text = "What is the first level?", next = "node_4_A"},
        {text = "What is the second level?", next = "node_4_B"},
        {text = "back", next = "smug"}
    }
}

smug.node_4_A = {
    text = "Yes I have written 4 doctorate theses on psychic warfare and separated the field into two levels. What do you want to know?",
    options = {
        {text = "What is the first level?", next = "node_4_A_1"},
        {text = "What is the second level?", next = "node_4_A_2"},
        {text = "back", next = "node_4"}
    }
}

smug.node_4_A_1 = {
    text = "The first level of Psychic War is implicit.",
    options = {{text = "Implicit...? What do you mean implicit?", next = "node_4_A_1b"}},
}

smug.node_4_A_1b = {
    text = "Yeah it's implicit!",
    options = {{text = "Uhm... okay, nevermind.", next = "node_4"}}
}

smug.node_4_B = {
    text = "PSYCHIC WAR is based on three premises. Shared reality has collapsed. Reality Collapse is Irreversible. Politics is Reality Agnostic ",
    options = {{text = "thanks", next = 'node_4'}}
}

return smug
