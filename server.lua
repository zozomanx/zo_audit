-- Initialize Config
local Config = Config or {}
local Statements = {}
local pastebinApiKey = Config.pasteBinAPIKey

-- Search for statements using citizenid and send results to the player source who requested it
local function findStatements(src, searchData, selectedOption)


    CreateThread(function()
        -- print('thread started')

        -- Statements = MySQL.query.await('SELECT * FROM bank_statements where citizenid = ?', {searchData})
        if selectedOption == Config.citizenidName then
            Statements = MySQL.query.await('SELECT * FROM bank_statements where citizenid = ?', {searchData})
        else if selectedOption == Config.idName then
            Statements = MySQL.query.await('SELECT bs.account_name, bs.amount, bs.citizenid, bs.date, bs.id, bs.reason, bs.statement_type, p.cid FROM bank_statements bs JOIN players p ON bs.citizenid = p.citizenid WHERE p.cid = ?', {searchData})
        end

        end
       -- Statements = MySQL.query.await('SELECT bs.account_name, bs.amount, bs.citizenid, bs.date, bs.id, bs.reason, bs.statement_type, p.cid FROM bank_statements bs JOIN players p ON bs.citizenid = p.citizenid WHERE p.cid = ?', {searchData})

        -- print(#Statements .. ' statements found')

        -- Send event to client to update NUI results
        TriggerClientEvent('zo_audit:client:displayResults', src, Statements)
        -- print('after TriggerClientEvent')
    end)
end

-- Get event from client for searching statements
RegisterNetEvent('zo_audit:server:search', function(src, searchData, selectedOption)
    -- print('src is ' .. src)
    -- print(searchData)
    
        findStatements(src, searchData, selectedOption)
    
end)

-- Listen for the client export event and then export the statements to pastebin
RegisterNetEvent('zo_audit:server:export', function()
    -- print('Exporting to pastebin')
    local exportString = 'Account Name, Amount, Citizen ID, Date, ID, Reason, Statement Type\n'
    for i = 1, #Statements do
        -- Convert MySQL date/time to desired format
        local timestamp = Statements[i].date
        local date
        if type(timestamp) == "number" then
            -- Convert Unix timestamp (in milliseconds) to seconds
            timestamp = timestamp / 1000
            -- Convert to desired date format
            date = os.date('%Y-%m-%d %H:%M:%S', timestamp)
        else
            date = "Invalid Date"
        end
        exportString = exportString .. Statements[i].account_name .. ', ' .. Statements[i].amount .. ', ' .. Statements[i].citizenid .. ', ' .. date .. ', ' .. Statements[i].id .. ', ' .. Statements[i].reason .. ', ' .. Statements[i].statement_type .. '\n'
    end

    -- print(exportString)

    PerformHttpRequest('https://pastebin.com/api/api_post.php', function(statusCode, response, headers)
         print(statusCode)
         print(response)
         -- print(headers)
    end, 'POST', 'api_dev_key=' .. pastebinApiKey .. '&api_option=paste&api_paste_private=1&api_paste_code=' .. exportString, {['Content-Type'] = 'application/x-www-form-urlencoded'})
end)