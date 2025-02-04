
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

## **Dialogue System & State Machine Reference Sheet**

### **- Example Dialogue File (JSON Format)**

```json
{
    "intro": {
        "text": "Welcome to Pond Academy. What do you seek?",
        "options": [
            {"text": "Knowledge", "next": "knowledge"},
            {"text": "Power", "next": "power"}
        ]
    },
    "knowledge": {
        "text": "Knowledge is endless, but are you prepared for it?",
        "options": [
            {"text": "Yes", "next": "end"},
            {"text": "No", "next": "intro"}
        ]
    },
    "power": {
        "text": "Power comes with responsibility. Do you accept it?",
        "options": [
            {"text": "Yes", "next": "end"},
            {"text": "No", "next": "intro"}
        ]
    },
    "end": {
        "text": "Your path is set.",
        "options": []
    }
}
```

---

### **- Entry Point: `intro.lua` (State)**
```lua
local intro = {}
local Dialogue = require("source.dialogue")

function intro:enter()
    self.dialogue = Dialogue:new("data/dialogue.json")
    self.dialogue:set_node("intro") -- Set entry node
end

function intro:update(dt)
    -- Update logic if needed (e.g., animations)
end

function intro:draw()
    self.dialogue:draw()
end

function intro:keypressed(key)
    self.dialogue:keypressed(key)

    if key == "return" and self.dialogue.current_node == "end" then
        State:enableMenu() -- Transition to menu after dialogue ends
    end
end

function intro:mousepressed(x, y, button)
    self.dialogue:mousepressed(x, y, button)
end

return intro
```

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
