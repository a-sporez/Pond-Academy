
# Premise

*Humanity is slowly dying after losing contact with Earth, the only way colonies/stations have to communicate is through wide/tight beam delayed messages setup in chat rooms, users are represented by critter avatars*


## **Dialogue Structure & Player Interaction**
- **Interrogative Gameplay** – Players ask questions, compare answers, and deduce hidden faction alignments.
- **Dynamic Faction Affiliation** – Each Critter shifts faction identity per session, preventing rote memorization.
- **Probabilistic Personality Traits** – Variable traits create unpredictability, ensuring replay value.
- **Cross-Referencing Mechanics** – Encourages investigation through dialogue + external source material.

## **Thematic Core of Pond Academy**
- **Philosophy of Knowledge** – Critters engage in debates on how truth is constructed, preserved, and weaponized.
- **Anonymity & Hidden Agendas** – Each Critter masks their true alignment behind rhetoric and deception.
- **The Zone & The Void** – Possible external anomalies influencing memory, communication, and ideology.
- **Intellectual Factions** – Competing ideological frameworks drive discourse, echoing real-world academic and political tension.

## **Critter Traits & Personality System**
- **Core Traits (Immutable)** – Define a Critter’s fundamental **mode of thinking** and **speech patterns** (Dogmatic, Skeptical, Pragmatic, Evasive).
- **Variable Traits (Probabilistic)** – Adds unique **behavioral quirks** with a randomized chance (Verbose, Elitist, Paranoid, Humorous).
- **Truth/Ideology Assignment** – A pool of **philosophical worldviews** assigned per session to align Critters with different factions.

## **Ideological "Truths"**
- *Historical Accuracy* – "The past must be preserved as it was."
- *Social Constructivism* – "Truth is shaped by those in power."
- *Technological Determinism* – "The future is inevitable, shaped by machines."
- *Mysticism & Esotericism* – "The Void speaks; it is our duty to interpret."
- *Anarchic Relativism* – "No truth is absolute; everything is a perspective."
- *Totalitarian Objectivism* – "Only one truth exists, and it must be enforced."

## **Worldbuilding Consistency**
- **Pond Academy in the Sci-Fi Universe** – Possibly an intellectual outpost or a derelict, centuries-old knowledge repository.
- **Factions Reflecting the Wider Game World** – Ideologies may tie into major player choices, reinforcing long-term consequences.
- **Communication System Influence** – Photon-based transmission may introduce distortions, delays, or censorship.
- **The Void’s Effect on Truth** – A lurking presence that alters memory, twisting what is known and unknown.

---

### Gameplay flow

* Exerts and critters: Each segment of a game starts with an exert during which an event will be investigated.
    + 5 exerts represent the entry point of a dialogue tree, they are static and explain one of each ideological truths.
    + 3 critters explain the "truth" about the events. *Each critters needs a way to explain for each possible attribute*

* Events: Events are distributed when the first game state is initialized, after the menu state. They have static initial attributes but outcomes are defined by the exert and critters.

---

### **- How the Dialogue System Works in the State Machine**
- **State Transitions:**
  - When `intro.lua` starts, it loads the `Dialogue` system.
  - Pressing "Enter" on the last dialogue node moves to the `menu` state.

- **Handling Input:**
  - Number keys select dialogue options.
  - Pressing Enter on the last dialogue node exits dialogue and switches states.

- **Loading & Executing Actions:**
  - The `execute_actions()` method in `Dialogue.lua` can trigger in-game effects.

---

### **- Example Cheat Sheet for Developers**
| Action | Code Example |
|--------|-------------|
| **Load dialogue file** | `local dlg = Dialogue:new("dialogue.json")` |
| **Set dialogue node** | `dlg:set_node("intro")` |
| **Render dialogue** | `dlg:draw()` |
| **Select option (keyboard)** | `dlg:keypressed("1")` |
| **Select option (mouse)** | `dlg:mousepressed(x, y, button)` |
| **Change game state** | `State:switch(require('source.states.menu'))` |

---

```lua
Dialogue = {}
Dialogue.__index = Dialogue

function Dialogue:new(dialogue_file)
    -- Load dialogue, initialize components
end

function Dialogue:load_dialogue(file_path)
    -- Load JSON or Lua table, store in self.dialogue_tree
end

function Dialogue:set_node(node_id)
    -- Set current node, check for conditions
end

function Dialogue:draw()
    -- Render text, options, and UI
end

function Dialogue:draw_text(text, x, y, width)
    -- Handle text rendering
end

function Dialogue:draw_options(options, x, y, width)
    -- Render choices, check for conditions
end

function Dialogue:keypressed(key)
    -- Handle input (number key selection)
end

function Dialogue:mousepressed(x, y, button)
    -- Handle mouse clicks (optional)
end

function Dialogue:on_choice_selected(choice_index)
    -- Move to next dialogue node, execute actions
end

function Dialogue:conditions_met(choice)
    -- Check if a choice is available based on game state
end

function Dialogue:execute_actions(choice)
    -- Execute effects like giving items, setting flags, or changing variables
end

function Dialogue:track_choices()
    -- Store selected choices for later reference
end

function Dialogue:return_to_previous_state()
    -- Exit dialogue and return to the game
end
```
