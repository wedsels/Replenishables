--- @param _S _S
--- @param _V _CV
return function( _S, _V )
    --- @class _CF
    local _F = {}

    _F.UpdateStrings = function( ent )
        local r = ent and ent.Vars and ent.Vars.Replenishables
        if not r then return end

        for uuid,levels in pairs( r ) do
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
    end

    return _F
end