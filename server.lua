-- Initialize Config
local Config = Config or {}
local Statements = {}

-- Search for statements using citizenid and send results to the player source who requested it
local function findStatements(src, searchData)


    CreateThread(function()
        -- print('thread started')

        -- Statements = MySQL.query.await('SELECT * FROM bank_statements where citizenid = ?', {searchData})
        Statements = MySQL.query.await('SELECT bs.account_name, bs.amount, bs.citizenid, bs.date, bs.id, bs.reason, bs.statement_type, p.cid FROM bank_statements bs JOIN players p ON bs.citizenid = p.citizenid WHERE p.cid = ?', {searchData})

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

-- Exporting might need Statements to be global, do a check if Statements is null