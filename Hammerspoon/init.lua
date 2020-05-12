local mappings = {}

local function remap(fromKey, toKey)
    mappings[fromKey] = {toKey = toKey}
end

local function mapKeyAction(fromKey, action)
    mappings[fromKey] = {action = action}
end

local function mapAction(fromKey, action)
    local keyAction = function(e, mapping)
        action(e, mapping)
        return {}
    end
    
    mapKeyAction(fromKey, keyAction)
end

local function getEventModifiers(eventFlags)
    local result = {}
    for _, mod in pairs({'ctrl', 'cmd', 'shift', 'fn'}) do
        if eventFlags[mod] then
            table.insert(result, mod)
        end
    end

    return result
end

local function handleKeyEvent(e)
    if e:getFlags().fn then
        local mapping = mappings[hs.keycodes.map[e:getKeyCode()]]

        if mapping then
            local isDown = e:getType() == hs.eventtap.event.types.keyDown

            if mapping.action then
                if isDown then
                    local newEvents = mapping.action(e, mapping)
                    return true, newEvents
                end
            elseif mapping.toKey then
                local isRepeat = e:getProperty(hs.eventtap.event.properties.keyboardEventAutorepeat)
                local modifiers = getEventModifiers(e:getFlags())

                local newEvent = hs.eventtap.event.newKeyEvent(modifiers, mapping.toKey, isDown)
                newEvent:setProperty(hs.eventtap.event.properties.keyboardEventAutorepeat, isRepeat)

                return true, {newEvent}
            end
        end
    end
end

local function start()
    hs.eventtap.new({hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp}, handleKeyEvent):start()
end

remap('k', 'left')
remap(';', 'right')
remap('l', 'down')
remap('o', 'up')

remap('i', 'home')
remap('p', 'end')
remap(',', 'pageup')
remap('.', 'pagedown')

remap('d', 'forwarddelete')

mapAction('f', function() hs.window.focusedWindow():maximize(0) end)

start()
