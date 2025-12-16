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

    Ext.Events.Tick:Subscribe(
        function()
            local ent = _C()
            if ent then
                _F.UpdateStrings( ent )
            end
        end
    )
end