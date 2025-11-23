/datum/techweb_node/magitechnology //totally not magic we promise xoxo - nanotrasen
	id = "magitechnology"
	display_name = "Introductory Thaumokinetics"
	description = "Manipulation of fundamental forces via technologicaly-assisted alteration of previously unknown quantum fields. Erroneously refered to as magic by some." // its totally magic NT is definitely in denial
	prereq_ids = list("engineering")
	required_items_to_unlock = list(
		/obj/item/codex_cicatrix,
		/obj/item/veilrender,
		/obj/item/spellbook,
		/obj/item/melee/cultblade,
		/obj/item/melee/sickly_blade,
		/obj/item/mod/control/pre_equipped/enchanted,
		/obj/item/clockwork/clockwork_slab,

	)
	design_ids = list(
		"antimagicprojector",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	hidden = TRUE
