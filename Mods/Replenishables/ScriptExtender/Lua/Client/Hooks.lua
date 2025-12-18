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

    local tick = 0
    Ext.Events.Tick:Subscribe(
        function()
            tick = tick + 1

            if tick > 30 then
                tick = 0

                local ent = _C()
                if ent and ent.Vars.ReplenishablesModified then
                    for uuid,levels in pairs( ent.Vars.ReplenishablesModified ) do
                        _F.UpdateStrings( ent, uuid, levels )
                    end

                    ent.Vars.ReplenishablesModified = {}
                end
            end
        end
    )
end