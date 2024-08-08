-- Initialize Config
local Config = Config or {}

local CIDName = Config.citizenidName
local SiteName = Config.siteName
local IdName = Config.idName

-- Debug
Wait(100)

function InitNUI()
    SendNUIMessage(
        {
            action = 'initVariables',
            citizenidName = CIDName,
            siteName = SiteName,
            idName = IdName
        }
    )
end

InitNUI()

function SetDisplay(bool)
    -- NuiDisplay = bool
    SetNuiFocus(bool, bool)
    -- print('Sending NUI message to open window')
    SendNUIMessage(
        {
            action = "openAudit"
        }
    )
end

-- Debug
SetDisplay(true)

-- Set ox_target BoxZone
exports.ox_target:addBoxZone(
    {
        coords = Config.auditComputer,
        size = vec3(1, 1, 1),
        rotation = 45,
        debug = false,
        options = {
            {
                name = "Audit Terminal",
                event = "zo_audit:client:openui",
                icon = "fa-solid fa-computer",
                label = "Open audit terminal"
            }
        }
    }
)

-- EventHandler for clicking inside of the BoxZone
AddEventHandler(
    "zo_audit:client:openui",
    function()
        -- print('Target Clicked, opening window.')
        SetDisplay(true)
    end
)

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
    TriggerServerEvent('zo_audit:server:search', src, searchData.searchData)

    cb('ok')
end)

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


-- debug

--[[ function tprint (tbl, indent)
    if not indent then indent = 0 end
    local toprint = string.rep(" ", indent) .. "{\r\n"
    indent = indent + 2 
    for k, v in pairs(tbl) do
      toprint = toprint .. string.rep(" ", indent)
      if (type(k) == "number") then
        toprint = toprint .. "[" .. k .. "] = "
      elseif (type(k) == "string") then
        toprint = toprint  .. k ..  "= "   
      end
      if (type(v) == "number") then
        toprint = toprint .. v .. ",\r\n"
      elseif (type(v) == "string") then
        toprint = toprint .. "\"" .. v .. "\",\r\n"
      elseif (type(v) == "table") then
        toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
      else
        toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
      end
    end
    toprint = toprint .. string.rep(" ", indent-2) .. "}"
    return toprint
  end ]]