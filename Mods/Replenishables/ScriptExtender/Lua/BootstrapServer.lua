Ext.Vars.RegisterUserVariable( "Replenishables", {
    Server = true,
    Client = true,
    WriteableOnServer = true,
    WriteableOnClient = false,
    Persistent = true,
    SyncToClient = true,
    SyncToServer = false,
    SyncOnTick = true,
    SyncOnWrite = false,
    DontCache = false,
} )

local _S = require( "Shared" )
local _V = require( "Server/Variables" )( _S )
local _F = require( "Server/Functions" )( _S, _V )
local _H = require( "Server/Hooks" )( _S, _V, _F )

if MCM then
    local function UpdateStats()
        for type,link in pairs( _V.AbilityCooldownLink ) do
            link.Scale = MCM.Get( _S.CooldownSource[ type ] .. "Scale" )
            link.Combat = MCM.Get( _S.CooldownSource[ type ] .. "Combat" )
        end
    end

    UpdateStats()

    Ext.ModEvents.BG3MCM[ "MCM_Setting_Saved" ]:Subscribe(
        function( payload )
            if not payload or payload.modUUID ~= ModuleUUID or not payload.settingId then
                return
            end

            UpdateStats()
        end
    )
end