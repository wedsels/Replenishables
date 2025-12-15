--- @param _S _S
--- @param _V _SV
--- @param _F _SF
return function( _S, _V, _F )
    Ext.Osiris.RegisterListener( "KilledBy", 4, "before", function( _, attacker ) _F.TriggerCooldown( Ext.Entity.Get( attacker ), _S.CooldownSource.Kill ) end )
    Ext.Osiris.RegisterListener( "CastedSpell", 5, "before", function( caster ) _F.TriggerCooldown( Ext.Entity.Get( caster ), _S.CooldownSource.Cast ) end )
    Ext.Osiris.RegisterListener( "AttackedBy", 7, "before", function( defender, attacker, _, _, damage ) if damage > 0 then _F.TriggerCooldown( Ext.Entity.Get( defender ), _S.CooldownSource.Hurt ) _F.TriggerCooldown( Ext.Entity.Get( attacker ), _S.CooldownSource.Attack ) end end )
    Ext.Osiris.RegisterListener( "TurnStarted", 1, "before", function( uuid ) _F.TriggerCooldown( Ext.Entity.Get( uuid ), _S.CooldownSource.Turn ) end )

    Ext.Entity.OnChange(
        "SpellBookCooldowns",
        function( ent )
            if not ent.Vars.Replenishables then
                ent.Vars.Replenishables = _S.DefaultResources()
            end

            local seen = {}

            for _,spell in pairs( ent.SpellBookCooldowns.Cooldowns ) do
                local name = spell.SpellId.Prototype
                if _S.Resources[ name ] then
                    _F.Replenishable( ent, name, 0 ).Set( ent.Stats and ent.Stats.Abilities[ _V.AbilityCooldownLink[ _S.CooldownSource.Reduction ].Ability ] * _V.AbilityCooldownLink[ _S.CooldownSource.Reduction ].Scale or 0 )

                    _F.UpdateProgress( ent )

                    seen[ name ] = true
                end
            end

            for uuid,levels in pairs( ent.Vars.Replenishables ) do
                if not seen[ uuid ] and not levels[ "1" ] and tonumber( levels[ "0" ] ) > -1.0 and Ext.Stats.Get( uuid ) then
                    _F.Replenishable( ent, uuid, 0 ).Set( -1.0 )

                    _F.UpdateProgress( ent )
                end
            end
        end
    )

    Ext.Entity.OnChange(
        "ActionResources",
        function( ent )
            if not ent.Vars.Replenishables then
                ent.Vars.Replenishables = _S.DefaultResources()
            end

            for uuid,levels in pairs( ent.ActionResources.Resources ) do
                for _,resource in ipairs( levels ) do
                    if _S.Resources[ uuid ] then
                        local rep = _F.Replenishable( ent, uuid, resource.Level )

                        if resource.Amount < resource.MaxAmount then
                            if rep.Get() < 0.0 then
                                rep.Set( ent.Stats and ent.Stats.Abilities[ _V.AbilityCooldownLink[ _S.CooldownSource.Reduction ].Ability ] * _V.AbilityCooldownLink[ _S.CooldownSource.Reduction ].Scale or 0 )
                            end

                            _F.UpdateProgress( ent )
                        elseif rep.Get() > -1.0 then
                            rep.Set( math.maxinteger )

                            _F.UpdateProgress( ent )
                        end
                    end
                end
            end
        end
    )
end