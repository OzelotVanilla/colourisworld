class_name GameSaveMapsState
extends Resource
## Wrapper class for dict saving state by map


## Actual stored data. Wrapped to avoid direct modification.[br][br]
##
## Map-specified event flag:[br]
## * First key ([String]): [member BaseMap.id].[br]
## * Second key ([String]): event name.
@export var _stored_state_by_map: Dictionary[String, Dictionary]


## Get event state or flag in a specific map.
func getState(map_id: String, event_or_flag_name: String) -> Variant:
    var map_state_dict: Dictionary = self._stored_state_by_map.get(map_id)
    if map_state_dict == null:
        return null

    return map_state_dict.get(event_or_flag_name)

## Set event state or flag in a specific map.
func setState(map_id: String, event_or_flag_name: String, state_value: Variant) -> void:
    var map_state_dict: Dictionary = self._stored_state_by_map.get_or_add(map_id, {})
    map_state_dict.set(event_or_flag_name, state_value)

## Erase one state in a specific map.
func eraseState(map_id: String, event_or_flag_name: String) -> void:
    var map_state_dict: Dictionary = self._stored_state_by_map.get(map_id)
    if map_state_dict == null:
        return

    map_state_dict.erase(event_or_flag_name)

## Erase all state in one map by deleting the entry of the map.
func eraseAllStateForMap(map_id: String) -> void:
    self._stored_state_by_map.erase(map_id)
