--- @param _S _S
--- @param _V _CV
--- @param _F _CF
return function( _S, _V, _F )
    Ext.Events.StatsLoaded:Subscribe( _F.UpdateAbilities )

    _S.Channel:SetHandler( function( data, user ) _F.UpdateStrings( data.uuid, data.levels ) end )
end