-- Initialize Config
local Config = Config or {}
local AuditStatements = {}
local Statements = {}

print('server started')

-- Search for statements using citizenid
local function findStatements(src, searchData)

    local src = src
    CreateThread(function()
        -- print('thread started')

        Statements = MySQL.query.await('SELECT * FROM bank_statements where citizenid = ?', {searchData})

        -- print(#Statements .. ' statements found')

        -- Send event to client to update NUI results
        TriggerClientEvent('zo_audit:client:displayResults', src, Statements)
        -- print('after TriggerClientEvent')
    end)
end

-- Get event from client for searching statements
RegisterNetEvent('zo_audit:server:search', function(src, searchData)
    -- print('src is ' .. src)
    -- print(searchData)
    findStatements(src, searchData)
end)