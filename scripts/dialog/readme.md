`dialog` Folder
========


Definitions of dialog resources.


Effect System
--------

A string representing the side-effect to bring to the whole game system.
Especially, the modification of the game global/by-map state.

### Specification

All effect follows this pattern `<command> <scope> <key> <value>`, connected by `;`.
The operation is done in a manner of **dictionary**.

`<command>` could be these keyword:
* `set`: Set value for key.
* `get`: Get value by key.
* `del`: Delete (erase) a key and its value. `del map *` will delete all entries in current map.
* `inc`: Increase a value by given `<value>`, searched by key. Fail if value is not number.
* `dec`: Decrease a value by given `<value>`, searched by key. Fail if value is not number.

`<scope>` could be these keyword:
* `global`: Global state.
* `map`: Map-only state.

`<key>` is a string that obeys to godot's variable naming rules.
`.` could be used if there is a hierarchical structure.

`<value>` is a string representing a string or a numeric value (checked by `String.is_valid_int` or `is_valid_float`).
If it is not a numeric number, it falls back to numeric type.