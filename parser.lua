-- file: parser.lua

local module = {}

local function split(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end


local function dispatch_cmd(client, message)
    if message == 'ping' then
        client:publish(myconf.mqtt_topic.."/cmd/status", "pong", 0, 0)
    elseif message == 'reset' then
        client:publish(myconf.mqtt_topic.."/cmd/reset", "pong", 0, 0)
        node.restart()
    end

end


local function process_json(client, message)
    local isok, result = pcall(sjson.decode, message)
    if isok then
        local status = {}
        if result['color'] ~= nill then
            l.set_color(
                result['color']['r'],
                result['color']['g'],
                result['color']['b']
            )
            status['color'] = {
                r = result['color']['r'],
                g = result['color']['g'],
                b = result['color']['b']
            }
        end

        if result['state'] == "ON" then
            l.slide_on()
            status['state'] = 'ON'
        elseif result['state'] == "OFF" then
            l.slide_off()
            status['state'] = 'OFF'
        end

        client:publish(myconf.mqtt_topic.."/status", sjson.encode(status), 0, 0)
    else
        print('json decode error: '..message)
    end
end


function module.mqtt_dispatch(client, topic, message)
    -- print ("topic: "..topic.." message: "..message)
    local tokens = split(topic, "/")
    local last_token = tokens[#tokens]

    if last_token == 'set' then
        process_json(client, message)
    elseif last_token == 'cmd' then
        dispatch_cmd(client, message)
    end
end

return module
