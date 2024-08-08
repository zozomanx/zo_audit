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