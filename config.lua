Config = {}

-- Set to true if you want to use the target box zone 
Config.UseTarget = true

-- Set to true if you want to use the command to open the audit terminal anywhere
Config.UseCommand = false

-- Location of computer you want to have audit access
Config.Locations = {
    vec3(249.26, 228.78, 105.18),
}

-- Allowed jobs to access the audit terminal
Config.allowedJobs = {
    "judge",
}

-- Set the name in the dropdown to what you use, like Citizen ID/SSN
Config.citizenidName = 'SSN'

-- Set the name in the dropdown of CID, like CID/ID
Config.idName = 'ID Number'

-- Set the name of the application
Config.siteName = 'Financial Transaction Audit'

-- Set the Pastee API key - Register: https://paste.ee/register - Get key: https://paste.ee/account/api
Config.pasteeAPIKey = 'YOUR_PASTEE_API_KEY'