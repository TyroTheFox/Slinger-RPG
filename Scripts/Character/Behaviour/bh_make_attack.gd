@tool
extends ActionLeaf

@export var npc_action: NPC_Action

func tick(actor: Node, _blackboard: Blackboard) -> int:
	if not actor:
		return FAILURE
	
	npc_action.execute(0)
	
	return SUCCESS
