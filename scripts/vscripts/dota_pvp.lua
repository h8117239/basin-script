
require("utils")
require("heroes")

MAX_CD = 12.0
BASE_CD = 8.0
MIN_CD = 1.5

MIN_INT = 30
BASE_INT = 80
MAX_INT = 110

MUILT_TARGET = true
TARGET_NUM = 1
MULT_TARGET_CONSTANT = 1.4

DO_FLAG_DAMAGE_ONCE = 10000  
FLAG_HP = 80000

function PrintHello(args)


end

function ExchangeFlag( args )
  local target = args.Target
  local caster = args.caster
  local ability = args.ability
  -- local basedamage = args.ability:GetAbilityDamage() 
  -- local cooldown = ability:GetCooldown(ability:GetLevel() )
  local targets = args.target_entities
  local targetsNum = table.getn(targets)
  print("DestroyFlag>>>>>>>>>>>>>>>>>>>>>>>>")
  print(targetsNum)
  local goods = 0
  local bads = 0

      for k,v in pairs(targets) do
        -- print(k,v)
        if v:IsRealHero() then
          print("is hero")
          if v:GetTeamNumber()==DOTA_TEAM_GOODGUYS then
            goods=goods+1
          elseif v:GetTeamNumber()==DOTA_TEAM_BADGUYS then
            bads = bads+1
          end
        end
      end
print("create " .. goods .. bads)
if goods==bads then  
    CureIfHPReduce(caster)
elseif goods>bads then
  if caster:GetTeamNumber() ~= DOTA_TEAM_GOODGUYS then
    DoDamage(caster,DO_FLAG_DAMAGE_ONCE,DAMAGE_TYPE_PURE,caster)
  else
    CureIfHPReduce(caster)
  end 
elseif caster:GetTeamNumber() ~= DOTA_TEAM_BADGUYS then
     DoDamage(caster,DO_FLAG_DAMAGE_ONCE,DAMAGE_TYPE_PURE,caster)
       else
    CureIfHPReduce(caster)
end
    print("<<<<<<<<<<<<<<<<<<<<<<<<<DestroyFlag")
end


function CureIfHPReduce( caster)
  if caster:GetHealth() < FLAG_HP then
    local ModMaster = CreateItem("modifier_master", nil, nil) 
    ModMaster:ApplyDataDrivenModifier(caster, caster, "modifier_hp_re_per", {duration = 1})

  end
end

function SpawnFlag( args  )
  local target = args.Target
  local caster = args.caster
  local ability = args.ability
  -- local basedamage = args.ability:GetAbilityDamage() 
  -- local cooldown = ability:GetCooldown(ability:GetLevel() )
  local targets = args.target_entities
  local targetsNum = table.getn(targets)
  print("SpawnFlag>>>>>>>>>>>>>>>>>>>>>>>>")
  print(targetsNum)
  -- PrintTable(args)
  -- print(targetsNum)
  -- print(ability)

if caster:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
  -- CreateUnitByName("npc_dota_flag", caster:GetOrigin(),  true, nil , nil, DOTA_TEAM_BADGUYS)
  CreateUnitByName("npc_dota_bad_flag", caster:GetCenter(),  true, nil , nil, DOTA_TEAM_BADGUYS)
elseif caster:GetTeamNumber() == DOTA_TEAM_BADGUYS then
  -- CreateUnitByName("npc_dota_flag", caster:GetOrigin(),  true, nil , nil, DOTA_TEAM_BADGUYS)
  CreateUnitByName("npc_dota_good_flag", caster:GetCenter(),  true, nil , nil, DOTA_TEAM_GOODGUYS)
else 
  local goods = 0
  local bads = 0

      for k,v in pairs(targets) do
        -- print(k,v)
        if v:IsRealHero() then
          if v:GetTeamNumber()==DOTA_TEAM_GOODGUYS then
            goods=goods+1
          elseif v:GetTeamNumber()==DOTA_TEAM_BADGUYS then
            bads = bads+1
          end
        end
      end

print("create " .. goods .. bads)
if goods==bads then
  CreateUnitByName("npc_dota_flag", caster:GetCenter() , true, nil , nil, DOTA_TEAM_NEUTRALS)
elseif goods>bads then
  CreateUnitByName("npc_dota_good_flag", caster:GetCenter(),  true, nil , nil, DOTA_TEAM_GOODGUYS) 
else
  CreateUnitByName("npc_dota_bad_flag", caster:GetCenter(),  true, nil , nil, DOTA_TEAM_BADGUYS) 
end

end
  print("<<<<<<<<<<<<<<<<<<<<<<<<<SpawnFlag")
end

function DoDamage( target,damage,damage_type,attacker )
      local damageTable = {
      victim = target,
      damage = damage,
      damage_type = damage_type,
      attacker = attacker,
      -- damage_flags = 0,
      -- ability = args.ability,
    }
      -- PrintTable(damageTable)
      ApplyDamage(damageTable)   
end


--根据技能基础伤害 技能CD和智力计算技能的法伤加成
--目前 整体额外伤害不超过技能伤害的3倍
function CalExMagicDamage( basedamage, cd, intellect, targetNum ,...)
      local cd_val  =MIN_CD
      if cd < MIN_CD then 
        cd_val = MIN_CD
      elseif 
        cd > MAX_CD then
        cd_val = MAX_CD
      else 
        cd_val = cd
      end
     local int = MIN_INT
     if intellect>MAX_INT then
      int = MAX_INT
      elseif intellect>MIN_INT then
        int = intellect
      end
      local targetPerct = 1.0
      if targetNum then 
        if targetNum > 4 then
          targetPerct = MULT_TARGET_CONSTANT/4
          elseif targetNum>1 then
            targetPerct =  MULT_TARGET_CONSTANT/targetNum
            end

      end
      return basedamage*cd_val*intellect*targetPerct/BASE_INT/BASE_CD
end
-- 眩晕效果
STUNED_MODIFIER = "modifier_stunned"
SLOW_MODIFIER = "modifier_item_orb_of_venom_slow"
---------------------------------------
-- mirana的减速技能伤害
---------------------------------------
function MiranaSlowArrow( args )
      -- PrintTable(args)
  
  local target = args.Target
  local caster = args.caster
   local ability = args.ability
  local basedamage = args.ability:GetAbilityDamage() 
  local cooldown = ability:GetCooldown(ability:GetLevel() )
  local targets = args.target_entities
  local targetsNum = table.getn(targets)
  local stun = 
    {
      duration = 2
    }
  local slow = 
  {
  duration  = 5,
  slow = -200
}
  local totalDamage = CalExMagicDamage(basedamage,cooldown,caster:GetIntellect(),targetsNum) + basedamage
  print("damage =============== " .. totalDamage)
  PrintTable(args)
     
      -- local targets = Entities:FindInSphere(nil, target, 200) 
      -- PrintTable(targets)

      for i,v in pairs(targets) do
        if(v) then
        DoDamage(v,totalDamage,DAMAGE_TYPE_MAGICAL,caster)
        v:AddNewModifier(caster, ability, SLOW_MODIFIER, slow) 
    end
  end
      -- local damageTable = {
      -- victim = v,
      -- damage = totalDamage,
      -- damage_type = DAMAGE_TYPE_MAGICAL,
      -- attacker = caster,
      -- -- damage_flags = 0,
      -- ability = args.ability,}
      -- -- PrintTable(damageTable)
      -- ApplyDamage(damageTable)  
 end


---------------------------------------------------
--mirana的眩晕基础攻击技能---------------
----------------------------------------------
function  MiranaStunArrow( args )
      local target = args.Target
  local caster = args.caster
   local ability = args.ability
  local basedamage = args.ability:GetAbilityDamage() 
  local cooldown = ability:GetCooldown(ability:GetLevel() )
  local targets = args.target
  local targetsNum = 1
  local stun = 
    {
      duration = 0.1
    }
  local totalDamage = CalExMagicDamage(basedamage,cooldown,caster:GetIntellect(),targetsNum) + basedamage
  print("damage =============== " .. totalDamage)
  PrintTable(args)
     
  DoDamage(targets,totalDamage,DAMAGE_TYPE_MAGICAL,caster)
  targets:AddNewModifier(caster, ability, STUNED_MODIFIER, stun) 

end






function PrintLeave(trigger)
	local act = trigger.activator
	print(act)
	for i,v in pairs(act) do
		print(i,v)
	end
	local cal = trigger.caller
	print(cal)
	for i,v in pairs(cal) do
		print(i,v)
	end
	print("hello I'm out")
	-- body
end


function PrintStatistic(  )
    for nPlayerID=0,9 do

    local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
    if hero and hero:IsAlive() then
      print(hero:GetName() )
      print("strength " .. hero:GetStrength() )
       print("helth " .. hero:GetHealth() )
       print("gold " .. hero:GetGold() )
    end

  end
end


