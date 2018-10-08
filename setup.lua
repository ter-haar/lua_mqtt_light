-- file: setup.lua
local module = {}

function module.init_mqtt(dispatch)
    print("Setting up MQTT...")
    local m = mqtt.Client(node.chipid(), 120)

    tmr.alarm(3, 1000, tmr.ALARM_AUTO,
        function()
            print('mqtt: wait for wifi')
            if wifi.sta.status() == wifi.STA_GOTIP then
                tmr.unregister(3)

                m:on("message", dispatch)
                m:on("offline", function(client) print ("mqtt offline") end)
                m:lwt(myconf.mqtt_topic.."/info", "offline", 0, 1)

                m:connect(myconf.mqtt_host, myconf.mqtt_port,
                    function(client)
                        print("MQTT connected")
                        client:publish(myconf.mqtt_topic.."/info", "online", 0, 1)
                        client:publish(myconf.mqtt_topic.."/ip", wifi.sta.getip(), 0, 1)
                        client:subscribe(myconf.mqtt_topic.."/#", 0)
                    end,
                    function(client)
                        print("MQTT error")
                    end
                )
            end
        end
    )
end


function module.init_wifi()
    print("Setting up WIFI...")
    wifi.setmode(wifi.STATION)
    wifi.sta.config{ssid=myconf.main_wifi_ssid, pwd=myconf.main_wifi_pwd}
    wifi.sta.connect()

    local led_value = false
    tmr.alarm(1, 100, tmr.ALARM_AUTO,
        function()
            gpio.write(pins.blue_led, led_value and gpio.HIGH or gpio.LOW)
            led_value = not led_value
        end
    )

    tmr.alarm(2, 1000, tmr.ALARM_AUTO,
        function()
            if wifi.sta.status() ~= wifi.STA_GOTIP then
                print("wifi: wait for IP...")
            else
                tmr.unregister(1)
                tmr.unregister(2)
                gpio.write(pins.blue_led, gpio.HIGH)
                print("Wifi connected: IP: "..wifi.sta.getip())
            end
        end
    )
end


function module.init_leds()
    gpio.mode(pins.blue_led, gpio.OUTPUT)
    gpio.write(pins.blue_led, gpio.HIGH)
end

return module
