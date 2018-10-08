--config.lua

myconf = {
    main_wifi_ssid="ssid_here",
    main_wifi_pwd="password_here",
    second_wifi_ssid="second_ssid_here",
    second_wifi_pwd="password_here",
    mqtt_host="192.168.24.115",
    mqtt_port=1883,
    mqtt_id=node.chipid(),
    mqtt_topic="home/light/LUA-"..node.chipid(),
}

pins = {
    blue_led = 4
}

led_strip = {
    leds = 60
}
