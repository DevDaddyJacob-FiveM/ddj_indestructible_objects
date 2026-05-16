local function getWorldProps()
    local i = 0
    local props = {}

    local findHandle = -1
    local propHandle = -1
    local findNextSuccess = false

    findHandle, propHandle = FindFirstObject()
    if 3 == GetEntityType(propHandle) then
        props[i] = propHandle
        i = i + 1
    end

    propHandle = -1


    findNextSuccess, propHandle = FindNextObject(findHandle)
    while findNextSuccess do
        if 3 == GetEntityType(propHandle) then
            props[i] = propHandle
            i = i + 1
        end

        propHandle = -1
        findNextSuccess, propHandle = FindNextObject(findHandle)
    end


    EndFindObject(findHandle)
    return props
end


Citizen.CreateThread(function()
    local origConfig = Config["IndestructibleModels"]
    Config["IndestructibleModels"] = {}

    for _, hash in ipairs(origConfig) do
        Config["IndestructibleModels"][hash] = true
    end

    while true do
        Citizen.Wait(500)

        for _, handle in ipairs(getWorldProps()) do
            if nil == Config["IndestructibleModels"][GetEntityModel(handle)] then
                goto continue
            end

            if IsEntityPositionFrozen(handle) then
                goto continue
            end

            FreezeEntityPosition(handle, true)
            SetEntityCanBeDamaged(handle, false)

            ::continue::
        end
    end
end)