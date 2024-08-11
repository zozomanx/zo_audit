-- Initialize Config
local Config = Config or {}

local CIDName = Config.citizenidName
local SiteName = Config.siteName
local IdName = Config.idName
local pasteeAPIKey = Config.pasteeAPIKey

-- Small wait to files to load and pass variables to NUI
Wait(5000)

----------- FUNCTIONS -----------

-- Function to initialize NUI variables from the Config file
function InitNUI()
    SendNUIMessage(
        {
            action = 'initVariables',
            citizenidName = CIDName,
            siteName = SiteName,
            idName = IdName,
            pasteeAPIKey = pasteeAPIKey

        }
    )
end

-- Function to open the NUI display
function SetDisplay(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage(
        {
            action = "openAudit"
        }
    )
end
----------- END FUNCTIONS -----------

----------- Initialize -----------

InitNUI()

----------- End Initialize -----------

----------- DEBUG -----------

-- Debug auto open audit window when restarted
-- SetDisplay(true)

----------- END DEBUG -----------

----------- TARGET -----------

if Config.UseTarget then
    CreateThread(function()
        for i = 1, #Config.Locations do
            local v = Config.Locations[i]
            exports['qb-target']:AddBoxZone('Audit' .. i, vector3(v.x, v.y, v.z), 1, 1, {
                name = 'Audit' .. i,
                debugPoly = false,
                heading = -20,
                minZ = v.z - 2,
                maxZ = v.z,
            }, {
                options = {
                    {
                        type = 'client',
                        event = 'zo_audit:client:openui',
                        icon = 'fa-solid fa-computer',
                        label = 'Open Audit Terminal',
                        job = Config.allowedJobs
                    }
                },
                distance = 2
            })
        end
    end)
end

----------- END TARGET -----------

----------- EVENT HANDLERS -----------

-- EventHandler for clicking inside of the BoxZone
RegisterNetEvent(
    "zo_audit:client:openui",
    function()
        SetDisplay(true)
    end
)


-- Listen for event from server and then sent NUI message to JS with the results from the search query in statementQuery
RegisterNetEvent('zo_audit:client:displayResults',function (statementQuery)
    -- print('Got NUI result update request ' .. tprint(statementQuery))

    SendNUIMessage(
        {
            action = "updateResults",
            statements = statementQuery
        }
    )

end)

----------- END EVENT HANDLERS -----------


----------- NUI CALLBACKS -----------

-- Release NUI focus
RegisterNUICallback('closeAudit', function(_, cb)
    SetNuiFocus(false, false)

    cb('ok')
end)

-- Wait for the NUI search callback and then trigger the server event sending playerid and search data
RegisterNUICallback('search', function(searchData, cb)
    -- print(searchData.searchData)
    local src = GetPlayerServerId(PlayerId())

    -- print('Client script src is ' .. src)
    TriggerServerEvent('zo_audit:server:search', src, searchData.searchData, searchData.startDate, searchData.endDate, searchData.selectedOption)

    cb('ok')
end)


-- -- This is used if having the LUA server do the export

-- -- Wait for the NUI export callback and then trigger the csv export function
-- RegisterNUICallback('export', function(_, cb)
--     -- print(tprint(Statements))

--     TriggerServerEvent('zo_audit:server:export')
--     print('Triggered Client to server Export')

--     cb('ok')
-- end)

----------- END NUI CALLBACKS -----------