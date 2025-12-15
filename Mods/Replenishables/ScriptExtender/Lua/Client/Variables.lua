--- @param _S _S
return function( _S )
    --- @class _CV
    local _V = {}

    _V.PreviousResources = _S.DefaultResources()

    --- @class Handle
    --- @field Handle string
    --- @field Original string

    --- @type table< string, Handle >
    _V.Handles = {}
    for uuid,_ in pairs( _V.PreviousResources ) do
        local data = Ext.Stats.Get( uuid ) or Ext.StaticData.Get( uuid, "ActionResource" )
        if data then
            _V.Handles[ uuid ] = {
                Handle = data.Description.Handle and data.Description.Handle.Handle or data.Description,
                Original = ""
            }
        end

        _V.Handles[ uuid ].Original = Ext.Loca.GetTranslatedString( _V.Handles[ uuid ].Handle )
        _V.Handles[ uuid ].Original = _V.Handles[ uuid ].Original:match( "^(.-)<>" ) or _V.Handles[ uuid ].Original

        Ext.Loca.UpdateTranslatedString( _V.Handles[ uuid ].Handle, _V.Handles[ uuid ].Original )
    end

    return _V
end