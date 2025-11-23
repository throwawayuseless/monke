/obj/item/antimagic_projector
	name = "thamuokinetic redirection unit"
	desc = "A wearable miniature thaumokinetic field projector is focused via a variety of synthetic high-purity gemstone lenses, causing any other such fields to flow around the wearer without impacting them. Comes with a lanyard."
	strip_delay = 20 // easy to remove
	icon = 'icons/obj/aicards.dmi'
	icon_state = "aicard"
	slot_flags = ITEM_SLOT_NECK

/obj/item/antimagic_projector/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/anti_magic, \
		antimagic_flags = MAGIC_RESISTANCE, \
		inventory_flags = ITEM_SLOT_NECK, \
		charges = 3, \
		drain_antimagic = CALLBACK(src, PROC_REF(drain_antimagic)), \
		expiration = CALLBACK(src, PROC_REF(expire)), \
	)

/obj/item/antimagic_projector/process(seconds_per_tick)
	 //will it regain all its charges in seconds? will it refuse to work sanely? who knows..
	if(GetComponent(/datum/component/anti_magic))
		var/datum/component/anti_magic/ourcomp = GetComponent(/datum/component/anti_magic)
		if(SPT_PROB(7.5, seconds_per_tick))
			ourcomp.charges = max(ourcomp.charges + 1, 3)
		if(ourcomp.charges >= 3)
			STOP_PROCESSING(SSprocessing, src)

/obj/item/antimagic_projector/examine(mob/user)
	. = ..()
	if(GetComponent(/datum/component/anti_magic))
		. += span_warning("A small embossing reads: \"Prone to overload. Allow unit to stabilize between uses.\"")
		var/datum/component/anti_magic/ourcomp = GetComponent(/datum/component/anti_magic)
		switch(ourcomp.charges)
			if(1)
				. += span_danger("It's shaking violently and buzzing deafeningly!")
			if(2)
				. += span_warning("It's humming loudly and glowing brightly.")
			if(3)
				. += span_notice("It's active and stable.")

/obj/item/antimagic_projector/proc/drain_antimagic()
	visible_message(span_warning("[src] hums, its lenses glowing."))
	START_PROCESSING(SSprocessing, src)

/obj/item/antimagic_projector/proc/expire()
	visible_message(span_danger("[src] begins glowing with blinding brightness!"))
	if(iscarbon(loc))
		var/mob/living/carbon/oughed = loc
		to_chat(oughed, span_userdanger("Oh fuck."))
	visible_message(span_danger("[src] violently overloads, releasing an explosive pulse of energy and falling apart!"))
	for(var/mob/living/fool in orange(2))
		fool.flash_act(4, FALSE, TRUE, length = 0.5 SECONDS)
		if(!fool.can_block_magic(MAGIC_RESISTANCE, 1))// yes this CAN cause a horrible chain reaction. nyehehe
			switch(rand(1, 5))
				if(1)
					fool.electrocute_act(25, src, flags = SHOCK_NOGLOVES)
					fool.visible_message(span_danger("[fool] is surrounded by a violent electrical pulse!"), span_userdanger("ZZZZTTTT!"))
				if(2)
					fool.adjust_fire_stacks(10)
					fool.ignite_mob()
				if(3)
					fool.vomit(10, FALSE, TRUE)
					fool.adjust_disgust(100)
					fool.apply_status_effect(/datum/status_effect/no_gravity, 30 SECONDS)
					fool.visible_message(span_warning("[fool] begins floating around!"), span_warning("You feel nauseous and weightless!"))
				if(4)
					fool.apply_status_effect(/datum/status_effect/freon/magic_overload)
					fool.visible_message("[fool] is frozen in a giant block of ice!")
					fool.adjustFireLoss(20)
				if(5)
					to_chat(fool, span_boldnotice("You seem fine, actually."))
					addtimer(CALLBACK(TYPE_PROC_REF(/mob/living, pay_for_your_sins), fool), rand(10 SECONDS, 10 MINUTES)) //hehe

/mob/living/proc/pay_for_your_sins()
	podspawn(list(
		"path" = /obj/structure/closet/supplypod/anvil/stun,
		"target" = src,
		))
	sleep(3.4 SECONDS)
	if(iscarbon(src))
		AddElement(/datum/element/squish,  99 HOURS) // SQUEESHED FOREVER, YOU FOOL

