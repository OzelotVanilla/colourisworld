class_name ChatChoiceOptionResource
extends Resource
## Choice option, for the chat with choices.


## Descriptive short comment for the meaning of the option.
@export var comment: String

@export_group("Translations", "tr__")

## Japanese translation.
@export var tr__ja: ChatChoiceDialogVariantResource

## Chinese (Traditional) translation.
@export var tr__zh: ChatChoiceDialogVariantResource

## English translation.
@export var tr__en: ChatChoiceDialogVariantResource

## Japanese (original text) translation.
@export var tr__ja_original: ChatChoiceDialogVariantResource
