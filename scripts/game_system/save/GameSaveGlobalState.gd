class_name GameSaveGlobalState
extends Resource
## Wrapper class for dict saving game global state


## Actual stored data.
## Wrapped to avoid direct modification.
@export var _stored_glbal_state: Dictionary[String, Variant]


## Get a global event state or flag.
func getState(event_or_flag_name: String) -> Variant:
    return self._stored_glbal_state.get(event_or_flag_name)

## Set a global event state or flag.
func setState(event_or_flag_name: String, state_value: Variant) -> void:
    self._stored_glbal_state.set(event_or_flag_name, state_value)

## Erase a global event state or flag.
func eraseState(event_or_flag_name: String) -> void:
    self._stored_glbal_state.erase(event_or_flag_name)
