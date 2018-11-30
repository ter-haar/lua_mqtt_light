# H801 vs lua
## Kolejny sterownik RGB led oparty na mqtt.

Po co? Bo żaden z tych które znalazłem nie miał tego co potrzebowałem. Sterownik jest przeznaczony głównie dla H801 WiFi (ale może działać na dowolnym układzie opartym o esp8266) i pozwala sterować niezależnie każdym z kanałów. Można więc podłączyć pasek rgb i sterować nim, a zupełnie osobno sterować jeszcze dwoma paskami mono. Albo sterować osobno 5 paskami monohromatycznymi.

Kod jest napisany w lua - głównie dlatego, że chciałem sprawdzić co sobie lepiej radzi - python/lua czy może arduino C++.

-------------------
* [Opis instalacji](install_pl.md)
* [Konfiguracja HomeAssistanta](hass_pl.md)
* [Mqtt](mqtt_pl.md)
