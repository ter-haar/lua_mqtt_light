-- file: leds.lua
local module = {
    color = {255, 255, 255},
    brightness = 255,
    speed = 10,
    effect = "solid",
    status = "ON",
    buffer = ws2812.newBuffer(led_strip.leds, 3),
}


function module.init()
    ws2812.init()

    module.on_all()
    tmr.alarm(4, 500, tmr.ALARM_SINGLE, module.off_all)
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


function module.animate()
    if module.effect == "solid" then
        if module.status == "ON" then
            module.on_all()
        else
            module.off_all()
        end

    elseif module.effect == "slide" then
        local color = module.color
        if module.status == "OFF" then
            color = {0, 0, 0}
        end

        local count = 1
        tmr.alarm(4, module.speed, tmr.ALARM_AUTO,
            function()
                if count > led_strip.leds then
                    tmr.unregister(4)
                else
                    module.buffer:set(count, color)
                    ws2812.write(module.buffer)
                    count = count + 1
                end
            end
        )
    end
end

return module
