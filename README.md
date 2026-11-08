# Tornado Wind Field Roblox Script

Tornado Wind Field is a Roblox script that creates a physics-based wind field effect: parts that touch the field become unanchored, rotate around a tornado object, rise over time, and receive a small outward and upward fling after a random 5–20 second duration.

## Install

1. Open your Roblox experience in Roblox Studio.
2. Create or select a `BasePart` to use as the trigger area and name it exactly `wind field`.
3. Enable `CanTouch` on the wind field. It may be transparent and non-collidable.
4. Create or select the tornado object and name it exactly `TORNADO`.
5. Make `TORNADO` either a `BasePart` or a `Model` containing at least one `BasePart`.
6. Insert `TornadoWindField.server.lua` as a normal server `Script` inside `ServerScriptService`.
7. Confirm that both named objects are somewhere under `Workspace`.
8. Start a play test and move a physical part into the wind field.

## Use

When a `BasePart` touches `wind field`, the script:

- Unanchors the touched part and the other parts connected to its physical assembly.
- Moves the assembly in a circular path around `TORNADO`.
- Raises the assembly while it circles.
- Runs the tornado motion for a random duration between 5 and 20 seconds.
- Applies an outward and upward fling when the motion ends.
- Ignores an assembly that is already being controlled by the tornado.

The script runs on the server and searches all descendants of `Workspace` for the required objects. To customize the effect, edit the configuration values at the top of the script, including the duration range, starting radius, rise speed, rotation speed, and fling strength.

---

More Roblox script projects by EnderDevelopment: https://github.com/EnderDevelopment

Project page: https://dash.enderdevelopment.com/community/1b99023c-2338-4b4f-9666-6e2ec838f9b4?utm_source=github&utm_medium=readme&utm_campaign=auto_publish&utm_content=1b99023c-2338-4b4f-9666-6e2ec838f9b4
