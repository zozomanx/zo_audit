-- Initialize Config
local Config = Config or {}

function SetDisplay(bool)
    NuiDisplay = bool
    SetNuiFocus(bool, bool)
    print('Sending NUI message to open window')
    SendNUIMessage(
        {
            type = "ui",
            status = bool
        }
    )
end

RegisterNUICallback(
    "close",
    function()
        SetNuiFocus(false, false)
        NuiDisplay = false
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
                event = "ox_target:zo_auditui",
                icon = "fa-solid fa-computer",
                label = "Open audit terminal"
            }
        }
    }
)

-- EventHandler for clicking inside of the BoxZone
AddEventHandler(
    "ox_target:zo_auditui",
    function()
        print('Target Clicked, opening window.')
        SetDisplay(true)
    end
)