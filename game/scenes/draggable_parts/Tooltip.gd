extends Panel

onready var title = $Title
onready var description = $Description

# warning-ignore:shadowed_variable
# warning-ignore:shadowed_variable
func setText(title, description):
	self.title.bbcode_text = title
	self.description.bbcode_text = description
	
