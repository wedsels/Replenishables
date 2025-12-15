--- @param _S _S
--- @param _V _CV
--- @param _F _CF
return function( _S, _V, _F )
    Ext.Events.StatsLoaded:Subscribe(
        function()
            function UpdateString( uuid, text )
                local s = Ext.Loca.GetTranslatedString( uuid )
                local m = s:match( "^(.-)<>" )
                s = m or s

                Ext.Loca.UpdateTranslatedString( uuid, s .. "<><br><br><LSTag Type=\"Image\" Info=\"TutorialLearnSpell\"/>Impacts " .. text .. " resource recovery.<br><br>" )
            end

            UpdateString( "haaf3959ag320eg4f68ga9c9gc143d7f64a8c", "on-kill" )
            UpdateString( "hbf128ebdgdfffg4ea9gbf4bg1659ccefd287", "on-attack" )
            UpdateString( "h7a02f64dg4593g408fgbf93gb0dbabc182c9", "on-hurt" )
            UpdateString( "h411a732ag4b4cg4094g9a5egd325fecf4645", "on-cast" )
            UpdateString( "h35233e68gf68ag461cgac5fgc15806be3dc7", "on-turn" )
            UpdateString( "h441085efge3a5g4004gba8dgf2378e8986c8", "starting" )

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