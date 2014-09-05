

cm_slow = "modifier_crystal_maiden_freezing_field_slow"

MOD_MASTER = CreateItem("modifier_master", nil, nil) 

function MakeMod(source,target, modifier_name, modifierArgs)
	 return MOD_MASTER:ApplyDataDrivenModifier(source,target,modifier_name,modifierArgs)
end




MODIFIER_INVISIBLE_AURE = function ( target )
	return MakeMod(target,target,"aure_modifer",{})
end


MODIFIER_SLOW = function ( target )
	return MakeMod(target,target,"modifier_slow",{})
end