--- @param _S _S
--- @param _V _CV
--- @param _F _CF
return function( _S, _V, _F )
    Ext.Events.StatsLoaded:Subscribe(
        function()
            _F.UpdateAbilities()

            for _,uuid in ipairs( Ext.StaticData.GetAll( "ActionResource" ) ) do
                if _S.Resources[ uuid ] then
                    Ext.StaticData.Get( uuid, "ActionResource" ).ShowOnActionResourcePanel = true
                end
            end
        end
    )

    Ext.Events.NetMessage:Subscribe(
        function( data )
            if data.Channel ~= _S.Channel then
                return
            end

            local payload = Ext.Json.Parse( data.Payload )
            _F.UpdateStrings( payload.uuid, payload.levels )
        end
    )
end