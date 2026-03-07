--- @param _S _S
--- @param _V _SV
return function( _S, _V )
    --- @class _SF
    local _F = {}

    _F.Replenishable = function( ent, uuid, level )
        level = tostring( level )

        return {
            Get = function()
                return ent.Vars.Replenishables and ent.Vars.Replenishables[ uuid ] and tonumber( ent.Vars.Replenishables[ uuid ][ level ] ) or -1.0
            end,
            Set = function( v )
                if not ent.Vars.Replenishables[ uuid ] then
                    ent.Vars.Replenishables = _S.DefaultResources()
                end

                ent.Vars.Replenishables[ uuid ][ level ] = v and tostring( v ) or v
                ent.Vars.Replenishables = ent.Vars.Replenishables

                if _V.Loaded then
                    _S.Channel:SendToClient( { uuid = uuid, levels = ent.Vars.Replenishables[ uuid ] }, _S.UUID( ent ) )
                end
            end
        }
    end

    _F.TriggerCooldown = function( ent, trigger )
        local abi = ent.Stats and ent.Stats.Abilities
        local link = _S.AbilityCooldownLink[ trigger ]
        if not abi or not link or link.Combat and ( not ent.CombatParticipant or not ent.CombatParticipant.CombatHandle ) then return end

        for uuid,levels in pairs( ent.Vars.Replenishables ) do
            for level,cooldown in pairs( levels ) do
                level = tonumber( level )
                cooldown = tonumber( cooldown )

                if level and cooldown then
                    if cooldown > -1.0 then
                        local rep = _F.Replenishable( ent, uuid, level )

                        rep.Set( rep.Get() + ( link.Ability and _S.Abilities[ link.Ability ] and abi[ _S.Abilities[ link.Ability ] ] or 1.0 ) * link.Scale )
                    end
                end
            end
        end

        _F.UpdateProgress( ent )
    end

    _F.UpdateProgress = function( ent )
        local ar = false
        local sbc = false

        for uuid,levels in pairs( ent.ActionResources.Resources ) do
            if _S.Resources[ uuid ] then
                for _,resource in pairs( levels ) do
                    local level = tonumber( resource.Level )

                    if level then
                        local rep = _F.Replenishable( ent, uuid, level )

                        local cooldown = rep.Get()
                        local cooled = _S.Cooldown( ent, uuid, level )

                        if cooldown and cooldown > -1.0 and cooled and cooldown >= cooled then
                            rep.Set( -1.0 )
                            resource.Amount = math.min( resource.MaxAmount, resource.Amount + 1 )
                            ar = true
                        end
                    end
                end
            end
        end

        for _,spell in ipairs( ent.SpellBookCooldowns.Cooldowns ) do
            local name = spell.SpellId.Prototype;

            if _S.Resources[ name ] then
                local rep = _F.Replenishable( ent, name, 0 )

                local cooldown = rep.Get()
                local cooled = _S.Cooldown( ent, name, 0 )

                if cooldown and cooldown > -1.0 and cooled and cooldown >= cooled then
                    rep.Set( -1.0 )
                    ent.SpellBookCooldowns.Cooldowns[ _ ] = nil
                    sbc = true
                end
            end
        end

        if ar then
            ent:Replicate( "ActionResources" )
        end

        if sbc then
            ent:Replicate( "SpellBookCooldowns" )
        end
    end

    return _F
end

