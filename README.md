# README

... or don't... it'd be great if you did though.

## Synopsis

The player awakens within the Pond Academy, a space station in the solar system created millions of years after humanity has been destroyed by an unknown event referred to as the "void". The station was build by transdimensional hyper-beings beyong human comprehension and the best they could do was recreate a few sentient conscious critters as accurately as possible after their science probe obtained the only remaining piece of human knowledge... a floating hard drive with all of the [Pondscum Podcast](https://www.youtube.com/@pondscumpodcast) on it.

In order to discover what happened to the human species, the player will have to question those critters and determine what part they playedin the destruction of the human species.

Workspace Environment:
install Love2D or link the source file to your IDE.

[LÖVE2D source](https://www.love2d.org)

LÖVE2D does not have an integrated environment, I use VS Code with git version control and the reference guide for coding.

[Love 11.5 Reference API](https://love2d-community.github.io/love-api/)

## Program Flow

### *Main file*

The LÖVE2D engine handles callbacks through:
[main.lua](main.lua)
There shouldn't be any gameplay logic in this file, anything not related to the GameStateManager can be connected through it without interfering with the game logic.
Any new callback should be added here then passed along the appropriate state in parameters.

### *Game State Manager*

GameStateManager is a static method to switch between finite game states, there shouldn't be anything written in this module except for functions to switch between each finite state. This ensures each individual state handles logic on it's own while avoiding redundancy.

[GameStateManager](source/states/GameStateManager.lua)

### *Menu State*

Menu is the game state that contains the ui elements, since this project will be run on a browser with static config there shouldn't be anything there but splash scene and play button but can be expanded to include out of game elements.

[Menu](source/states/menu.lua)

---

### *Running State*

Running State is where the main gameplay elements are initialized, for now it acts as a single game session initialized upon clicking the Play button.  The Dialogue module is the only thing it loads right now because I need to have some form of output to test the file structure.

Variable attributes will be along 4 branches defined by the initial dialogue options, each tiered conditional to each other meaning the event defines theories who then define blame :

- What happened? (events)
- How is it possible? (theories)
- Who is responsible? (blame)
- What should we do about it? (outcomes)

#### **TODO:** *Create dictionary of Variable traits to be used as conditionals during the distribution of "ideological truths"*

#### **TODO:** *Create method to distribute variable traits to each critter at the start of a game, use indexing of variable traits dictionary tables and arithmetic ranges with a math.random seed*

#### **TODO:** *Create 2D scene for archives and spread buttons*

[Running](source/states/running.lua)

---

### *Dialogue*

Dialogue is a metamethod that establishes the method to handle dialogue tables. For now the tables are just placeholders to provide output. The "Archives" table is initialized directly in the constructor, it branches into the dialogue assigned to each critter.

For now I am planning to hardcode the core attributes of each critter through the extended dialogue module attributed to them, so they will be largely arbitrarily defined based on the conditionals I set with the assigned attributes. It's supposed to remain vague and elusive but is not an actual attribute part of the game's logic... just an abstract definition of the method I used and how it would traslate into a core personality trait the player would easily recognize. Place to add one lore trait about each pondscum podcast character while leaving the actual personality attribution to be random.

#### **TODO:** *Each node as a metatable of Dialogue representing a branching dialogue with a single critter. The intended output for the first build*

#### **TODO:** *Create dictionary of "ideological truths"*

#### **TODO:** *Create method to assign ideological truths to each critter based on conditionals*

#### **TODO:** *Create dictionary of dialogue responses*

#### **TODO:** *Draw splash and animated sprite for each critter under the dialogue and buttons*

- [Dialogue](source/dialogues/dialogue.lua)

## Utility

### *Button*

Simple module to create buttons with a constructor, metatable and can be extended without messing around with the base method.

- [Button](source/ui/button.lua)

## Progress

- [x] game state manager
- [x] game flow blueprint
- [ ] dialogue tree
- [ ] background sprites
- [ ] critter sprites animation
- [ ] psychic warfare source material
- [ ] attributes assignment
- [ ] event outcomes

(...)
