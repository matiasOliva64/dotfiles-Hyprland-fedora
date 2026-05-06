#!/bin/bash

# Verificar actualizaciones (solo descarga metadatos)
updates=$(dnf check-update -q | grep -c '^\S')

if [ "$updates" -gt 0 ]; then
  notify-send "Actualizaciones disponibles" "Hay $updates paquetes listos para actualizar en Fedora." -i software-update-available
fi
