-- file: leds.lua
local module = {}

module.color = {255, 255, 255}
module.brightness = 255
module.speed = 10
module.buffer = ws2812.newBuffer(led_strip.leds, 3)

function module.init()
    ws2812.init()
end


function module.off_all()
    module.buffer:fill(0, 0, 0)
    ws2812.write(module.buffer)
end


function module.on_all()
    module.buffer:fill(module.color[1], module.color[2], module.color[3])
    ws2812.write(module.buffer)
end


function module.set_color(r, g, b)
    module.color[1] = g
    module.color[2] = r
    module.color[3] = b
end


function module.slide_on()
    local count = 1
    tmr.alarm(4, module.speed, tmr.ALARM_AUTO,
        function()
            if count > led_strip.leds then
                tmr.unregister(4)
            else
                module.buffer:set(
                    count,
                    module.color[1],
                    module.color[2],
                    module.color[3]
                )
                ws2812.write(module.buffer)
                count = count + 1
            end
        end
    )
end


function module.slide_off()
    local count = 1
    tmr.alarm(4, module.speed, tmr.ALARM_AUTO,
        function()
            if count > led_strip.leds then
                tmr.unregister(4)
            else
                module.buffer:set(count, {0, 0, 0})
                ws2812.write(module.buffer)
                count = count + 1
            end
        end
    )
end

return module
