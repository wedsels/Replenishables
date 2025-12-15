--- @param _S _S
return function( _S )
    --- @class _SV
    local _V = {}

    _V.AbilityCooldownLink = {
        [ _S.CooldownSource.Kill ] = {
            Ability = _S.Abilities.Strength,
            Scale = 0.1,
            Combat = false
        },
        [ _S.CooldownSource.Attack ] = {
            Ability = _S.Abilities.Dexterity,
            Scale = 0.01,
            Combat = true
        },
        [ _S.CooldownSource.Hurt ] = {
            Ability = _S.Abilities.Constitution,
            Scale = 0.045,
            Combat = false
        },
        [ _S.CooldownSource.Cast ] = {
            Ability = _S.Abilities.Intelligence,
            Scale = 0.015,
            Combat = true
        },
        [ _S.CooldownSource.Turn ] = {
            Ability = _S.Abilities.Wisdom,
            Scale = 0.06,
            Combat = true
        },
        [ _S.CooldownSource.Reduction ] = {
            Ability = _S.Abilities.Charisma,
            Scale = 0.18,
            Combat = false
        }
    }

    return _V
end