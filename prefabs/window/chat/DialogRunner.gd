class_name DialogRunner
extends Node
## Execute string-repr-ed side-effect


## Execute the effect string.[br][br]
##
## [param map_id] could be leaved as empty if it is not a map-scoped operation.
func executeEffect(effect_string: String, map_id: String = ""):
    var effects: PackedStringArray = effect_string.split(
        ";",
        false # Does not allow empty effect
    )

    if effects.size() <= 0:
        return

    for effect in effects:
        # make `effect` stripped and no empty array element, max split at 4.
        # Should convert to `Array` otherwise pattern-match fails.
        match Array(effect.strip_edges().split(" ", false, 4)):
            ["set", var scope, var key, var value]:
                if scope == "global":
                    save_manager.save.runtime__global_state.setState(
                        key, value
                    )
                elif scope == "map":
                    save_manager.save.runtime__maps_state.setState(
                        map_id, key, value
                    )
                else:
                    printerr("Unknown scope `", scope, "` in effect `", effect, "`.")

            ["get", var scope, var key]:
                if scope == "global":
                    save_manager.save.runtime__global_state.getState(
                        key
                    )
                elif scope == "map":
                    save_manager.save.runtime__maps_state.getState(
                        map_id, key
                    )
                else:
                    printerr("Unknown scope `", scope, "` in effect `", effect, "`.")

            ["del", var scope, var key]:
                if scope == "global":
                    save_manager.save.runtime__global_state.eraseState(
                        key
                    )
                elif scope == "map":
                    if key == "*":
                        save_manager.save.runtime__maps_state.eraseAllStateForMap(
                            map_id
                        )
                    else:
                        save_manager.save.runtime__maps_state.eraseState(
                            map_id, key
                        )
                else:
                    printerr("Unknown scope `", scope, "` in effect `", effect, "`.")

            ["inc", var scope, var key, var value]:
                self.incdecFor("inc", scope, key, value, effect, map_id)

            ["dec", var scope, var key, var value]:
                self.incdecFor("dec", scope, key, value, effect, map_id)

            _:
                printerr("Could not parse effect `", effect, "`.")

## Do NOT call this method directly.[br][br]
##
## Used by [method executeEffect].
func incdecFor(
    inc_or_dec: String, scope: String, key: String, value: String,
    effect: String, map_id: String
) -> void:
    if not value.is_valid_int() and not value.is_valid_float():
        printerr(
            "Value must be valid number but not`", value,
            "` in effect `", effect, "`."
        )
        return
    if inc_or_dec != "inc" and inc_or_dec != "dec":
        printerr("`inc_or_dec` must be `inc` or `dec`, but not `", inc_or_dec, "`")
        return

    var old_value: Variant # `int|float`
    if scope == "global":
        old_value = save_manager.save.runtime__global_state.getState(key)
    elif scope == "map":
        old_value = save_manager.save.runtime__maps_state.getState(map_id, key)
    else:
        printerr("Unknown scope `", scope, "` in effect `", effect, "`.")
        return

    var value_to_incdec: Variant # `int|float`
    if value.is_valid_int():
        value_to_incdec = int(value)
    else: # Must be float, because already checked if not number.
        value_to_incdec = float(value)

    var new_value: Variant
    if inc_or_dec == "inc":
        new_value = old_value + value_to_incdec
    else:
        new_value = old_value - value_to_incdec

    if scope == "global":
        save_manager.save.runtime__global_state.setState(key, new_value)
    else: # Checked by previous.
        save_manager.save.runtime__maps_state.setState(map_id, key, new_value)
