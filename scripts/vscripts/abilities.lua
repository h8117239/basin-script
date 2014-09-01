



MOD_MASTER = CreateItem("modifier_master", nil, nil) 

function MakeMod(source,target, modifier_name, modifierArgs)
	 return MOD_MASTER:ApplyDataDrivenModifier(source,target,modifier_name,modifierArgs)
end




MODIFIER_INVISIBLE_AURE = function ( target )
	print("MODDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD")
	return MakeMod(target,target,"aure_modifer",{duration = 99999})
end