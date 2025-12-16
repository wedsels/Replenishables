Ext.Vars.RegisterUserVariable( "Replenishables", {
    Server = true,
    Client = true,
    WriteableOnServer = true,
    WriteableOnClient = false,
    Persistent = true,
    SyncToClient = true,
    SyncToServer = false,
    SyncOnTick = true,
    SyncOnWrite = false,
    DontCache = false,
} )

local _S = require( "Shared" )
local _V = require( "Server/Variables" )( _S )
local _F = require( "Server/Functions" )( _S, _V )
local _H = require( "Server/Hooks" )( _S, _V, _F )