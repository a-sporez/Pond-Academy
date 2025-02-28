local smug = {}

smug.smug = {
    text = "What do you want from me!? I'm busy working on Psychic Warfare strategies.",
    options = {
        {text = "Smug!? What happened!?", next = 'node_1'}, -- TODO: Add 
        {text = "What is this place!?", next = 'node_2'},
        {text = "I... can't remember my name, who... what am I?", next = 'node_3'},
        {text = "Psychic Warfare, what is it?", next = 'node_4'}
    }
}

smug.node_1 = {
    text = "SmugBUG! I have no idea who that smug person is but I hate them. You should ask them what happened. Now leave me alone!",
    options = {
        {text = "Back", next = 'smug'}
    }
}

smug.node_2 = {
    text = "What do YOU MEAN!? YOU think that I KNOW?!? Look at me! I don't even have limbs, is this a joke?",
    options = {
        {text = "Back", next = 'smug'}
    }
}

smug.node_3 = {
    text = "Bwaahahhahaha get wreckt!! It's pretty obvious that you are some kind of angry bunny but really... deep down? Do you even know?",
    options = {
        {text = "Back", next = 'smug'}
    }
}

smug.node_4 = {
    text = "I have written 4 doctorate theses on psychic warfare and separated the field into two levels. What do you want to know?",
    options = {
        {text = "What is the first level?", next = 'node_4_A'},
        {text = "What is the second level?", next = 'node_4_B'},
        {text = "back", next = "smug"}
    }
}

smug.node_4_A = {
    text = "The first level of Psychic War is implicit.",
    options = {
        {text = "Implicit...? What do you mean implicit?", next = 'node_4_A_1'},
        {text = "That's not very helpful but thanks.", next = 'smug'}
    }
}

smug.node_4_A_1 = {
    text = "Yeah it's implicit!",
    options = {
        {text = "What does that even mean?", next = 'node_2'},
        {text = "Uhm... okay, nevermind.", next = 'node_4'}
    }
}

smug.node_4_B = {
    text = "PSYCHIC WAR is based on three premises. Shared reality has collapsed. Reality Collapse is Irreversible. Politics is Reality Agnostic ",
    options = {
        {text = "Is this what happened? Reality has collapsed?", next = 'node_4_A_1'},
        {text = "thanks", next = 'smug'}
    }
}

return smug
