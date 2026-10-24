# Quantum Mirror

Solo-developed 2D puzzle platformer with superposition state manipulation as the main mechanic.
Built in Godot, initially for a university course.

## TL;DR

The screen is split into two near-identical versions of each level, and the player acts as a qubit: |0> puts you in the upper level, |1> in the lower, and superposition puts you in both at once, with one set of controls moving both copies.

You collect limited-use quantum gates scattered through the level. H splits you into superposition and merges you back. Z flips your phase, which changes which level you exit into. X swaps you between levels when you’re not in superposition. Observers like surveillance cameras measure you and collapse you randomly into one level. Everything else is deterministic.

To win, you reach the exit. If both levels have an exit, both copies must reach it. If only one does, you must collapse into the right phase first. Dying (for example on spikes) or getting stuck restarts the level.

## About the Game

### Core Concept

**Quantum Mirror** is a level-based 2D puzzle platformer that uses superposition as the core element of the gameplay.

The screen is split into 2 parts, each showing the same level with small deviations. Player's goal is to reach the exit while using quantum gates X, Z and H as a resource throughout, but gates uses are limited and can be replenished by finding and collecting representations of gates in the level.

### Quantum Mechanics Model

This game implements a **simplified state-based model inspired by single-qubit quantum mechanics**:

- Superposition: This is a state system acting as a qubit. Reflected as same level being mirrored with some deviations and shown on the lower part of the screen.
  - |0> means single instance exists in the **upper** version of the level.
  - |1> means single instance exists in the **lower** version of the level.
  - |+> represents a superposition where the two manifestations have positive relative phase. For gameplay purposes, this corresponds to the **|0> exit phase**.
  - |−> represents a superposition where the two manifestations have negative relative phase. For gameplay purposes, this corresponds to the **|1> exit phase**.

- Z, X, H Gates: Act on the player's state the same way they act on a qubit. See [Game Mechanics and rules](#game-mechanics-and-rules) _Gates usage_ section below for their in-game effects.

- Measurement & Collapse: Certain in-game objects (e.g. surveillance cameras) act as observers. When one measures the player in superposition, the state collapses randomly to |0> or |1>: the manifestation in the matching level remains and the other one disappears.

- Entanglement: Although multiple manifestations may appear on screen, they represent a single underlying player entity. When in superposition, player input is applied to all manifestations simultaneously, while their coordinates may differ due to interactions with the environment.

### Comparison to Classical Probability Model

- Superposition allows simultaneous exploration and interaction of both level instances.
- Gates triggering and phase manipulation can give deterministic results, while measurement is the only thing that can cause random behaviour.
- Correlation between player instances allows puzzle mechanics that cannot be achieved with independent random events.

### Game Mechanics and rules

- Regular platforming movement, that includes moving left and right as well as jumping. If player's character is in superposition, then player controls both instances simultaneously.
- Power Sources: Pressure plates and levers that can be activated to power in-game elements like doors.
- Power Users: Objects that can be powered on and off like doors.
- A small inventory-like system for picking up gates scattered through the level
- **Gates usage:**
  - H gate: initially splits player into 2 instances one in each level version, thus entering superposition. Using gate again collapses instances resulting in a single instance existing in its entering phase (H|0> = |+>; H|+> = |0>) unless underlying phase was changed with Z gate.
  - Z gate: swaps the phase (exit state) of player in superposition.
  - X gate: swaps the player's basis state while outside superposition, allowing the player to travel between the two level versions.
- Hazards such as spikes can damage or kill the player's manifestation. If the underlying player entity is killed, the level restarts.
- Observers: Objects such as surveillance cameras measure the player's state (see [Quantum Mechanics Model](#quantum-mechanics-model) _Measurement & Collapse_ section).

### Winning and Losing Conditions

Goal of each level is to reach the end. If an exit exists in both versions of the level, both instances must reach the exit trigger, whilst if only a single version of the level has an exit, then player's character must exit superposition in the correct phase before reaching the exit trigger.

If destination is not reachable any more and/or player's character is killed (e.g. fallen into spikes) then it counts as a loss and level restarts.

## Platform and Development tools

**Platform:** PC/Desktop (Windows and Linux)

**Controls:** Keyboard and Mouse with partial Gamepad support

### Development Tools

**Game Engine:** Godot

**Programming Language:** GDScript (Godot's built-in scripting language)

**Tool for Art Assets:** Aseprite

**Tool for Sound Assets:** _TBA_
