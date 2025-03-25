local smug = {}

--[[
smug.node_ = {
    text = "Node ",
    options = {
        {text = "text", next = ''},
        {text = "back", next = 'smug'}
    }
}
--]]
-- smug's premise is mithridatism, introduction to Psychic Warfare.
smug.smug = {
    text = "What is going on!? What do you want from me!?",
    options = {
        {text = "Can you move out of the way?", next = 'node_1_A'},
        {text = "What happened!?", next = 'node_1'},
        {text = "What is this place!?", next = 'node_2'},
        {text = "I... can't remember my name, who... what am I?", next = 'node_3'},
    }
}

smug.node_1_A = {
    text = "No, I can't move out of the way.",
    options = {
        {text = "Why not?", next = 'node_1_Ab'}
    }
}

smug.node_1_Ab = {
    text = "You don't need to go over there, so stop asking me to move.",
    options = {
        {text = "Okay.", next = 'smug'}
    }
}

smug.node_1 = {
    text = "You should ask someone who works here. Now leave me alone!",
    options = {
        {text = "Work? What do you mean? What is this place?", next = 'node_2'},
        {text = "It says on the sign that you are Archivists.", next = 'node_2_A_1'},
        {text = "Right.", next = 'smug'}
    }
}

smug.node_2 = {
    text = "What do YOU mean!? You think that I know?!? Look at me! I don't even have limbs, is this a joke?",
    options = {
        {text = "I don't feel like joking, I am trying to understand...", next = 'node_2_B'},
        {text = "It says on the sign that you are Archivists.", next = 'node_2_A_1'},
        {text = "Nevermind.", next = 'smug'}
    }
}

smug.node_2_B = {
    text = "There is nothing to understand, it's implied.",
    options = {
        {text = "Implied? What do you mean?", next = 'node_2_A_1b'},
        {text = "Wow.", next = 'smug'}
    }
}

smug.node_2_A_1 = {
    text = "Yes I am an Archivist.",
    options = {
        {text = "What does that even mean?", next = 'node_2_A_1b'},
        {text = "Thanks.", next = 'smug'}
    }
}

smug.node_2_A_1b = {
    text = "I don't know, I thought you were supposed to know.",
    options = {
        {text = "I don't know anything. I am so confused right now.", next = 'node_3'},
        {text = "Is this the Archives?", next = 'node_2_A_1c'},
        {text = "Nope.", next = 'smug'}
    }
}

smug.node_2_A_1c = {
    text = "Archives are implicitly part of the Psychic War.",
    options = {
        {text = "War? Are we in any danger?", next = 'node_5'},
        {text = "Psychic War!? What is that?", next = 'node_4'},
        {text = "Okay.", next = 'smug'}
    }
}

smug.node_3 = {
    text = "Get wrecked!! It's pretty obvious that you are some kind of angry bunny. Do you even know?",
    options = {
        {text = "I am not angry, what are you talking about?", next = 'node_6'},
        {text = "Whatever.", next = 'smug'}
    }
}

smug.node_4 = {
    text = "I have written the psychic warfare manifesto and separated the field into two levels. What do you want to know?",
    options = {
        {text = "What is the first level?", next = 'node_4_A'},
        {text = "What is the second level?", next = 'node_4_F'},
        {text = "What is the third level?", next = 'node_4_B'},
        {text = "Thanks.", next = "smug"}
    }
}

smug.node_4_B = {
    text = "I didn't mention a third level.",
    options = {
        {text = "Ah! But there IS a third level?", next = 'node_4_Bb'},
        {text = "I don't understand! Did I do something wrong?", next = 'node_2_A_1b'},
        {text = "Nevermind.", next = 'smug'}
    }
}

smug.node_4_Bb = {
    text = "I am not going to correct you, or would you rather I correct you?",
    options = {
        {text = "I just want to understand what is happenning.", next = 'node_4_Bc'}
    }
}

smug.node_4_Bc = {
    text = "Don't we all want to understand what is happening?",
    options = {
        {text = "That's not, Ugh! Can you stop speaking in riddles?"},
        {text = "True.", next = 'node_COND1'}
    }
}

smug.node_COND1 = {
    text = "Everyone but you. There is only everyone until there is you.",
    options = {
        {text = "...", next = 'smug'}
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
        {text = "Sure.", next = 'smug'}
    }
}

smug.node_4_F = {
    text = "PSYCHIC WAR is based on three premises. Shared reality has collapsed. Reality Collapse is Irreversible. Politics is Reality Agnostic.",
    options = {
        {text = "Is this what happened? Reality has collapsed?", next = 'node_4_A_1'},
        {text = "Thanks.", next = 'smug'}
    }
}

smug.node_5 = {
    text = "Yes you are, do you think I can't see it?",
    options = {
        {text = "I don't understand what any of this means.", next = 'node_2_B'},
        {text = "Why do you think I'm angry? What happened?", next = 'node_5_B'},
        {text = "Whatever.", next = 'smug'}
    }
}

smug.node_5_B = {
    text = "Danger is always a possibility, you can always end up dead in the material plane.",
    options = {
        {text = "Ok, now you are starting to spook me out.", next = 'node_7'},
        {text = "Sure.", next = 'smug'},
    }
}

smug.node_6 = {
    text = "You certainly look angry.",
    options = {
        {text = "I'm not...", next = 'node_5'},
        {text = "Nope.", next = 'smug'}
    }
}

smug.node_7 = {
    text = "You should be spooked, I want you to be spooked. Fear is not your enemy if you know where it comes from.",
    options = {
        {text = "Why would you want to do that?", next = 'node_8'},
        {text = "Weird.", next = 'smug'}
    }
}

smug.node_8 = {
    text = "There are things corrupting reality, this reality, the only reality.",
    options = {
        {text = "What do you want me to do about it?", next = 'node_8_A'},
        {text = "Uhm.", next = 'smug'}
    }
}

return smug
