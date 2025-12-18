--- @param _S _S
--- @param _V _CV
return function( _S, _V )
    --- @class _CF
    local _F = {}

    _F.UpdateAbilities = function()
        local map = {
            [ _S.Abilities.Strength ] = "haaf3959ag320eg4f68ga9c9gc143d7f64a8c",
            [ _S.Abilities.Dexterity ] = "hbf128ebdgdfffg4ea9gbf4bg1659ccefd287",
            [ _S.Abilities.Constitution ] = "h7a02f64dg4593g408fgbf93gb0dbabc182c9",
            [ _S.Abilities.Intelligence ] = "h411a732ag4b4cg4094g9a5egd325fecf4645",
            [ _S.Abilities.Wisdom ] = "h35233e68gf68ag461cgac5fgc15806be3dc7",
            [ _S.Abilities.Charisma ] = "h441085efge3a5g4004gba8dgf2378e8986c8"
        }

        local links = {}

        for event,link in pairs( _S.AbilityCooldownLink ) do
            if _S.Abilities[ link.Ability ] then
                links[ _S.Abilities[ link.Ability ] ] = links[ _S.Abilities[ link.Ability ] ] or {}
                table.insert( links[ _S.Abilities[ link.Ability ] ], _S.CooldownSource[ event ] )
            end
        end

        for abi,uuid in pairs( map ) do
            local s = Ext.Loca.GetTranslatedString( uuid )
            local m = s:match( "^(.-)<>" )
            s = m or s

            local text = "<><br>"
            if links[ abi ] then
                for _,event in ipairs( links[ abi ] ) do
                    text = text .. "<br><LSTag Type=\"Image\" Info=\"TutorialLearnSpell\"/>" .. event .. " cooldown recovery"
                end
            end

            Ext.Loca.UpdateTranslatedString( uuid, s .. text .. "<br><br>" )
        end
    end

    _F.UpdateStrings = function( ent, uuid, levels )
        local string

        for level,cooldown in pairs( levels ) do
            level = tonumber( level )
            cooldown = tonumber( cooldown )

            if level and cooldown then
                if not _V.PreviousResources[ uuid ][ level ] or _V.PreviousResources[ uuid ][ level ] ~= cooldown then
                    _V.PreviousResources[ uuid ][ level ] = cooldown

                    string = string or "<><br><br>"

                    local cooled = _S.Cooldown( ent, uuid, level )

                    if cooled and cooldown > -1.0 then
                        local p = cooldown / cooled

                        if p < 1.0 then
                            string = string .. ( #_V.PreviousResources[ uuid ] > 1 and "Level: " .. level .. "<br>" or "" ) .. "<LSTag Type=\"Image\" Info=\"TutorialLearnSpell\"/>"
                            for i=1,18 do
                                if 1.0 / 18.0 * i > p then
                                    string = string .. "<LSTag Type=\"Image\" Info=\"WarlockSpellSlot\"/>"
                                else
                                    string = string .. "<LSTag Type=\"Image\" Info=\"SpellSlot\"/>"
                                end
                            end
                            string = string .. "<br><br>"
                        end
                    end
                end
            end
        end

        if string then
            Ext.Loca.UpdateTranslatedString( _V.Handles[ uuid ].Handle, _V.Handles[ uuid ].Original .. string )
        end
    end

    return _F
end