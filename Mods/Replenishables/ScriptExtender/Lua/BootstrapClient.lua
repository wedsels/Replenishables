Ext.Vars.RegisterUserVariable( "Replenishables", {
    Server = true,
    Client = true,
    WriteableOnServer = true,
    WriteableOnClient = true,
    Persistent = true,
    SyncToClient = true,
    SyncToServer = true,
    SyncOnTick = true,
    SyncOnWrite = false,
    DontCache = false,
} )

local _S = require( "Shared" )
local _V = require( "Client.Variables" )( _S )
local _F = require( "Client.Functions" )( _S, _V )
local _H = require( "Client.Hooks" )( _S, _V, _F )