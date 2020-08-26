 #!/bin/bash

/mnt/Docker/Hassio/homeassistant/
hass --script check_config

git add .
git status

echo -n "Pon la descripción del cambio: " [Escribe a continuación]
read CHANGE_MSG

git commit -m "${CHANGE_MSG}"
git push origin master
exit

