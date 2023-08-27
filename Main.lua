local frame = CreateFrame("Frame", "AltSavedInstances");
frame:RegisterEvent("ADDON_LOADED");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
frame:RegisterEvent("RAID_INSTANCE_WELCOME");
frame:RegisterEvent("PLAYER_LOGOUT");
frame:RegisterEvent("UPDATE_INSTANCE_INFO");

local variablesLoaded = false;

local function processSavedInstances()
    local now = time(); -- reset is in seconds from now, so we add that to now

    local savedInstances = {};
    for i = 1, GetNumSavedInstances() do
        local instanceInfo = {GetSavedInstanceInfo(i)};
        -- name, id, reset, difficulty, locked, extended, instanceIDMostSig,
        -- isRaid, maxPlayers, difficultyName
        
        instanceInfo[3] = instanceInfo[3] + now;

        for j = 1, #instanceInfo do
            instanceInfo[j] = tostring(instanceInfo[j]);
        end
        
        table.insert(savedInstances, table.concat(instanceInfo, "\t"));
    end
    AltSavedInstances_DB = table.concat(savedInstances, "\n");
end

local function eventHandler(self, event, arg1, ...)
    if event == "ADDON_LOADED" and arg1 == "AltSavedInstances" then
        -- prepare data just in case
        -- if AltSavedInstances_DB == nil then
        --     AltSavedInstances_DB = {}
        -- end
        -- variables loaded
        variablesLoaded = true;
        -- if not raid info requested already (weird), do so
        if (not instanceInfoRequested) then
            instanceInfoRequested = true;
            RequestRaidInfo();
        end
    elseif event == "UPDATE_INSTANCE_INFO" then
        if variablesLoaded then
            processSavedInstances();
        end
        instanceInfoRequested = false;
    else
        -- if not raid info requested already, do so
        if variablesLoaded and not instanceInfoRequested then
            instanceInfoRequested = true;
            RequestRaidInfo();
        end
    end
end


frame:SetScript("OnEvent", eventHandler);