# README

... or don't... it'd be great if you did read me though.

## Credits

Artist: [Penusbmic](https://penusbmic.itch.io)
Artist: [OscarTheSheep](https://www.twitch.tv/oscarthesheeptwitchver)
Lead Developer: [Spore](https://github.com/a-sporez)

## Progress Map

- [x] game state manager
- [x] dialogue tree
- [ ] attributes assignment
- [ ] event outcomes
- [~] load background sprites
- [~] load critter sprites
- [ ] animations

(...)

Workspace Environment:

[LÖVE2D source](https://www.love2d.org)

LÖVE2D does not have an integrated environment, I use VS Code with git version control and the reference guide for coding.

[Love 11.5 Reference API](https://love2d-community.github.io/love-api/)

Libraries:

[Simple Tiled Implementation](https://github.com/karai17/Simple-Tiled-Implementation)

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

Running State is where the main gameplay elements are initialized, Maps are initialized through this state so it acts as a scenes manager. This is not optimal but it should be sufficient for the scope of the project.

#### **TODO:** *Create dictionary of Variable traits to be used as conditionals during the distribution of "ideological truths"*

#### **TODO:** *Create method to distribute variable traits to each critter at the start of a game, use indexing of variable traits dictionary tables and arithmetic ranges with a math.random seed*

[Running](source/states/running.lua)

---

### *Dialogue*

Dialogue is a metamethod that with a factory pattern to make and assign nodes with simple Lua table.

- [Dialogue](source/dialogues/dialogue.lua)

#### *Nodes*

- [smug](source/dialogues/nodes/smug.lua)
- [olive](source/dialogues/nodes/olive.lua)
- [bambi](source/dialogues/nodes/bambi.lua)
- [wiz](source/dialogues/nodes/wiz.lua)

---

## Utility

### *Button*

Simple module to create buttons with a constructor, metatable and can be extended without messing around with the base method.

- [Button](source/ui/button.lua)

---

## Entities

For each entities in this section variables are consistent and metatable is set for possible modding or extension of functionality but there is no unified entity class/method.

### *Bunny*

Main user entity and current end point for user input, dialogue interactions are directly tied to this module.

- [Bunny](source/entities/bunny.lua)

### *Archivists*

Entities tied to a dialogue and loaded in a static position within the archives scene, smug, wiz, olive, bambi are the end point for each their own dialogue nodes however their dialogue initialization is contained within the Dialogue base class.

- [Archivists](source/entities/archivists.lua)

### *Critter*

Base class for entities that the player can spawn using resource accumulated, separated from other entities to allow modding and expansion without affecting the core entities.

#### **TODO:** *Attach to Running game state and Test initialization*

- [Critter](source/entities/critter.lua)

---

## Scenes

### Archives

Archives is the central scene where the dialogue with archivists occurs, resolving the dialogue with each archivist unlocks the associated scene. Each scene handles collision on its own using the tiled map table.

- [Archives](source/scenes/archives.lua)
- [archives_map](assets/scenes/archives_map.lua)
