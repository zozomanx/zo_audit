-- Initialize Config
local Config = Config or {}

function SetDisplay(bool)
    -- NuiDisplay = bool
    SetNuiFocus(bool, bool)
    print('Sending NUI message to open window')
    SendNUIMessage(
        {
            action = "openAudit"
        }
    )
end

RegisterNUICallback(
    "close",
    function()
        SetNuiFocus(false, false)
        -- NuiDisplay = false
        print('NUI Callback to close window')
    end
)

-- Set ox_target BoxZone
exports.ox_target:addBoxZone(
    {
        coords = Config.auditComputer, -- CHANGE TO PROPER COORDS
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
        print('Target Clicked, opening window.')
        SetDisplay(true)
    end
)

-- NUI Callback

RegisterNUICallback('closeAudit', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('search', function(searchData)
    print(searchData.searchData)
    TriggerServerEvent('zo_audit:server:search', searchData.searchData)
end)

RegisterNetEvent('zo_audit:client:displayResults',function (statementQuery)
    print('Got NUI result update request ' .. tprint(statementQuery))
    SendNUIMessage(
        {
            action = "updateResults",
            statements = statementQuery
        }
    )

end)


-- debug

function tprint (tbl, indent)
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
  end