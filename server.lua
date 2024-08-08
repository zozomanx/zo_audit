-- Initialize Config
local Config = Config or {}
local AuditStatements = {}
local Statements = {}

print('server started')

-- Search for statements using citizenid
local function findStatements(searchData)
    CreateThread(function()
        print('thread started')

        Statements = MySQL.query.await('SELECT * FROM bank_statements where citizenid = ?', {searchData})

        print(#Statements .. ' statements found')

        -- Send event to client to update NUI results
        TriggerClientEvent('zo_audit:client:displayResults', -1, Statements)
        print('after TriggerClientEvent')
    end)
end

-- Get event from client for searching statements
RegisterNetEvent('zo_audit:server:search', function(searchData)
    print(searchData)
    findStatements(searchData)
end)