extends Panel

onready var title = $Title
onready var description = $Description

func setText(title, description):
	self.title.bbcode_text = title
	self.description.bbcode_text = description
	
