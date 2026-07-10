class_name LanguageManager
extends Node
## Singleton of language manager
##
## Auto-loaded by this project,
##  named/accessed by [code]LanguageManager[/code].
## Class name not set-ed in order to avoid naming conflicted.


## Emit when the language changes to another language.
signal language_changed()


enum LanguageOption
{
    ## Languae is not defined.
    ## This should be considered an error in the game.
    undefined,
    ## The original text of the game.
    ja_original,
    ## Japanese translation, sometimes missing key information.
    ja,
    ## English translation, sometimes become too chyunibyo
    ##  and derived from the original meaning.
    en,
    ## Chinese (Traditional) translation.
    ## Unnatural and make a lot of mistake.
    ## Contains key information that is missing in Japanese translation.
    zh,
}


const language_order := [
    LanguageOption.ja,
    LanguageOption.en,
    LanguageOption.zh,
]


var current_language: LanguageOption:
    get():
        return self._stored__current_language

var _stored__current_language: LanguageOption:
    set = changeTo


func _ready() -> void: self.__onReady__()
func _unhandled_input(event: InputEvent) -> void: self.__onUnhandledInput__(event)


## Change current game language to a new languae.[br][br]
##
## Do nothing if the target [param language] is the same as [member current_language].
func changeTo(language: LanguageOption):
    if language == current_language:
        return

    # # Write to member.
    _stored__current_language = language

    # # Change game language as well.
    var lang_code: String
    match language:
        LanguageOption.ja:
            lang_code = "ja"
        LanguageOption.en:
            lang_code = "en"
        LanguageOption.zh:
            lang_code = "zh_TW"
        LanguageOption.ja_original:
            lang_code = "ja_original"
    TranslationServer.set_locale(lang_code)
    self.language_changed.emit()

## Changed by [method __onUnhandledInput__]
##  when player inputs action [code]ui_change_to_previous_language[/code]
##  or [code]ui_change_to_next_language[/code].[br][br]
##
## Setting this value cause the changing of language.
var current_language_index: int = 0:
    set(value):
        if current_language_index == value:
            return
        var length = LanguageManager.language_order.size()
        current_language_index = ((value % length) + length) % length
        self.changeTo(LanguageManager.language_order[current_language_index])

func __onReady__():
    # TODO: Load from last language used, from game save.
    self.changeTo(LanguageOption.ja)

## Does not allow echoed event.
func __onUnhandledInput__(event: InputEvent):
    if event.is_echo():
        return

    if   event.is_action_pressed("ui_change_to_previous_language"):
        self.current_language_index -= 1
    elif event.is_action_pressed("ui_change_to_next_language"):
        self.current_language_index += 1
