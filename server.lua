-- import { oxmysql as MySQL } from '@overextended/oxmysql'

-- Initialize Config
local Config = Config or {}
local AuditStatements = {}

print('server started')

local function findStatements(searchData)
    CreateThread(function()
        print('thread started')
        local statements = MySQL.query.await('SELECT * FROM bank_statements where citizenid = ?', {searchData})
        for _, statement in ipairs(statements) do
            -- AuditStatements[statement.account_name][#AuditStatements[statement.account_name] + 1] = statement
            -- print(statement.reason)
        end
        print(#statements .. ' statements found')
    end)
end

RegisterNetEvent('zo_audit:server:search', function(searchData)
    print(searchData)
    findStatements(searchData)
end)