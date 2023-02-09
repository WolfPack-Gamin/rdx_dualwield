RDX = nil
Citizen.CreateThread(function() while RDX == nil do	TriggerEvent('rdx:getSharedObject', function(obj) RDX = obj end) Citizen.Wait(0) end end)

local function getGuidFromItemId(inventoryId, itemData, category, slotId) 
    local outItem = DataView.ArrayBuffer(8 * 13)
 
    if not itemData then
        itemData = 0
    end
 
    local success = Citizen.InvokeNative("0x886DFD3E185C8A89", inventoryId, itemData, category, slotId, outItem:Buffer()) --InventoryGetGuidFromItemid
    if success then
        return outItem:Buffer() --Seems to not return anythign diff. May need to pull from native above
    else
        return nil
    end
end
 
local function addWardrobeInventoryItem(itemName, slotHash)
    local itemHash = GetHashKey(itemName)
    local addReason = GetHashKey("ADD_REASON_DEFAULT")
    local inventoryId = 1
 
    -- _ITEMDATABASE_IS_KEY_VALID
    local isValid = Citizen.InvokeNative("0x6D5D51B188333FD1", itemHash, 0) --ItemdatabaseIsKeyValid
    if not isValid then
        return false
    end
 
    local characterItem = getGuidFromItemId(inventoryId, nil, GetHashKey("CHARACTER"), 0xA1212100)
    if not characterItem then
        return false
    end
 
    local wardrobeItem = getGuidFromItemId(inventoryId, characterItem, GetHashKey("WARDROBE"), 0x3DABBFA7)
    if not wardrobeItem then
        return false 
    end
 
    local itemData = DataView.ArrayBuffer(8 * 13)
 
    -- _INVENTORY_ADD_ITEM_WITH_GUID
    local isAdded = Citizen.InvokeNative("0xCB5D11F9508A928D", inventoryId, itemData:Buffer(), wardrobeItem, itemHash, slotHash, 1, addReason);
    if not isAdded then 
        return false
    end
 
    -- _INVENTORY_EQUIP_ITEM_WITH_GUID
    local equipped = Citizen.InvokeNative("0x734311E2852760D0", inventoryId, itemData:Buffer(), true);
    return equipped;
end
 
local function givePlayerWeapon(weaponName, attachPoint)
    local addReason = GetHashKey("ADD_REASON_DEFAULT");
    local weaponHash = GetHashKey(weaponName);
    local ammoCount = 0;
 
    -- RequestWeaponAsset
    Citizen.InvokeNative("0x72D4CB5DB927009C", weaponHash, 0, true);
 
    Wait(1000)
    -- GIVE_WEAPON_TO_PED
    Citizen.InvokeNative("0x5E3BDDBCB83F3D84", PlayerPedId(), weaponHash, ammoCount, true, false, attachPoint, true, 0.0, 0.0, addReason, true, 0.0, false);
end
 
--[[RegisterCommand("dualwield", function()
    addWardrobeInventoryItem("CLOTHING_ITEM_M_OFFHAND_000_TINT_004", 0xF20B6B4A);
    addWardrobeInventoryItem("UPGRADE_OFFHAND_HOLSTER", 0x39E57B01);
    givePlayerWeapon("WEAPON_REVOLVER_CATTLEMAN", 2);
    givePlayerWeapon("WEAPON_REVOLVER_LEMAT", 3);
end)]]

if Config.AutoDualWield then
 Citizen.CreateThread(function()
    Citizen.Wait(5000)
    TriggerServerEvent('Activate:DualWield_SV', args)
    addWardrobeInventoryItem("CLOTHING_ITEM_M_OFFHAND_000_TINT_004", 0xF20B6B4A);
    addWardrobeInventoryItem("UPGRADE_OFFHAND_HOLSTER", 0x39E57B01);
    givePlayerWeapon("WEAPON_REVOLVER_CATTLEMAN", 2);
    givePlayerWeapon("WEAPON_REVOLVER_LEMAT", 3);
 end)
end

RegisterNetEvent('ActivateDualWield')
AddEventHandler('ActivateDualWield', function()
    addWardrobeInventoryItem("CLOTHING_ITEM_M_OFFHAND_000_TINT_004", 0xF20B6B4A);
    addWardrobeInventoryItem("UPGRADE_OFFHAND_HOLSTER", 0x39E57B01);
    givePlayerWeapon(MainArm, 2);
    givePlayerWeapon(SecondArm, 3);
end)