--init.lua

dofile("config.lua")
s = require("setup");
p = require("parser");
l = require("leds");

s.init_leds()
s.init_wifi()
s.init_mqtt(p.mqtt_dispatch)
l.init()
l.slide_on()


