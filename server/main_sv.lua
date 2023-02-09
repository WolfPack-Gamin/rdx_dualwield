
RDX = nil
TriggerEvent('rdx:getSharedObject', function(obj) RDX = obj end)

RDX.RegisterCommand('dualwield',function(source)  
 local xPlayer = RDX.GetPlayerFromId(source)  
 local MainArm = GetHashKey("WEAPON_REVOLVER_CATTLEMAN_JOHN")
 local SecondArm = GetHashKey("WEAPON_REVOLVER_DOUBLEACTION_GAMBLER")

 xPlayer.addWeapon("WEAPON_REVOLVER_CATTLEMAN_JOHN", 1)
 xPlayer.addWeapon("WEAPON_REVOLVER_DOUBLEACTION_GAMBLER", 1) 
 TriggerClientEvent('ActivateDualWield')  
end)


RegisterNetEvent('Activate:DualWield_SV')
AddEventHandler('Activate:DualWield_SV', function()
    local xPlayer = RDX.GetPlayerFromId(source)  
    local MainArm = GetHashKey("WEAPON_REVOLVER_CATTLEMAN_JOHN")
    local SecondArm = GetHashKey("WEAPON_REVOLVER_DOUBLEACTION_GAMBLER")
   
    xPlayer.addWeapon("WEAPON_REVOLVER_CATTLEMAN_JOHN", 1)
    xPlayer.addWeapon("WEAPON_REVOLVER_DOUBLEACTION_GAMBLER", 1)       
end)
