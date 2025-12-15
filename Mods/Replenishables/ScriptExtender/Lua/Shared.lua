--- @class _S
local _S = {}

_S.Abilities = {
    Strength = 2,
    Dexterity = 3,
    Constitution = 4,
    Intelligence = 5,
    Wisdom = 6,
    Charisma = 7
}

_S.ReplenishType = {
    Never = -1,
    Default = -1,
    Combat = 6,
    ShortRest = 8,
    ExhaustedRest = 12,
    FullRest = 12,
    Rest = 12,

    None = -1,
    OncePerTurn = -1,
    OncePerTurnNoRealtime = -1,
    OncePerCombat = 6,
    OncePerShortRest = 8,
    OncePerShortRestPerItem = 8,
    UntilRest = 12,
    OncePerRest = 12,
    UntilShortRest = 12,
    OncePerRestPerItem = 12,
    UntilPerRestPerItem = 12
}

_S.CooldownSource = {}
for index,type in ipairs( { "Kill", "Attack", "Hurt", "Cast", "Turn", "Reduction" } ) do
    _S.CooldownSource[ index ] = type
    _S.CooldownSource[ type ] = index
end

--- @returns table< string, table< integer, number > >
_S.DefaultResources = function()
    local ret = {}

    for _,uuid in ipairs( Ext.StaticData.GetAll( "ActionResource" ) ) do
        local data = Ext.StaticData.Get( uuid, "ActionResource" )

        if data and not data.PartyActionResource and _S.ReplenishType[ data.ReplenishType[ 1 ] ] > -1 then
            ret[ uuid ] = {}
            for i=0,data.MaxLevel do
                ret[ uuid ][ i ] = -1.0
            end
        end
    end

    for _,name in ipairs( Ext.Stats.GetStats( "SpellData" ) ) do
        local data = Ext.Stats.Get( name )

        if data and _S.ReplenishType[ data.Cooldown ] > -1 then
            ret[ name ] = { [ 0 ] = -1.0 }
        end
    end

    return ret
end

_S.Resources = _S.DefaultResources()

_S.UUID = function( target )
    if type( target ) == "userdata" and target.Uuid then
        return string.sub( target.Uuid.EntityUuid, -36 )
    elseif type( target ) == "string" then
        return string.sub( target, -36 )
    end
end

_S.Hash = function( str )
    local h = 5381

    for i = 1, #str do
        h = h * 32 + h + str:byte( i )
    end

    return h
end

_S.RNG = function( seed )
    local self = { seed = seed }

    setmetatable(
        self,
        {
            __call = function( _, range, reroll )
                local roll = 0
                range = range or 1
                reroll = reroll or 1

                for _ = 1, reroll do
                    self.seed = ( 1103515245 * self.seed + 12345 ) % 0x80000000
                    local r = self.seed / 0x80000000
                    if r > roll then
                        roll = r
                    end
                end
                local t = type( range )

                if t == "number" then
                    return roll * range
                elseif t == "table" then
                    return range[ math.floor( roll * #range + 1 ) ]
                end
            end
        }
    )

    return self
end

_S.GenUUID = function( seed )
    local ran = _S.RNG( _S.Hash( seed ) )

    return string.gsub(
        "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx",
        "[xy]",
        function( c )
            return string.format( "%x", c == "x" and math.floor( ran( 16 ) ) or 8 + math.floor( ran( 4 ) ) )
        end
    )
end

_S.Cooldown = function( ent, uuid, level )
    if not ent then return end

    local data = Ext.Stats.Get( uuid )
    if data then
        return _S.ReplenishType[ data.Cooldown ]
    end

    local levels = ent.ActionResources.Resources and ent.ActionResources.Resources[ uuid ]
    if not levels then return end

    for _,resource in ipairs( levels ) do
        if resource.Level == tonumber( level ) then
            return _S.ReplenishType[ resource.ReplenishType[ 1 ] ] / ( 1.0 + resource.Amount * 0.33 - math.max( 1.0, resource.Level ) * 0.33 )
        end
    end
end

return _S