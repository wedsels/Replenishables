local _S = require( "Shared" )
local _V = require( "Client.Variables" )( _S )
local _F = require( "Client.Functions" )( _S, _V )
local _H = require( "Client.Hooks" )( _S, _V, _F )

if MCM then
    Ext.ModEvents.BG3MCM[ "MCM_Setting_Saved" ]:Subscribe(
        function( payload )
            if not payload or payload.modUUID ~= ModuleUUID or not payload.settingId then
                return
            end

            _F.UpdateAbilities()
        end
    )
end