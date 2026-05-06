#!/bin/bash

function generate_output() {
  clients=$(hyprctl clients -j)
  active=$(hyprctl activeworkspace -j | jq '.id')
  output=""

  for i in 1 2 3 4 5 6 7; do
    icons=""
    # Extraer clases de apps en el workspace i
    apps=$(echo "$clients" | jq -r ".[] | select(.workspace.id==$i) | .class")

    for app in $apps; do
      case "${app,,}" in # Convertir a minúsculas para comparar
      *firefox*) icon="" ;;
      *chrome*) icon="" ;;
      *kitty* | *alacritty* | *foot*) icon="" ;;
      *vlc* | *mpv*) icon="󰕼" ;;
      *steam*) icon="" ;;
      *plasma-systemmonitor* | *btop* | *htop*) icon="" ;;
      *code* | *vscodium* | *visual-studio-code* | *jetbrains-idea* | *org.kde.kate*) icon="" ;;
      *discord* | *vesktop*) icon="" ;;
      *obs*) icon="" ;;
      *dolphin* | *nautilus* | *thunar*) icon="" ;;
      *okular*) icon="" ;;
      *kcalc* | *gnome-calculator*) icon="" ;;
      *java*) icon="☕" ;; # Para tu desarrollo Java
      *postman*) icon="󰛮" ;;
      *dbeaver* | *mysql* | *sqlite*) icon="" ;;
      *virt-manager*) icon="󰢹" ;;
      *spotify*) icon="" ;;
      *minecraft* | *prismlauncher*) icon="󰍳" ;; # Para tu proyecto de mods
      *xwaylandvideobridge*) continue ;;
      *) icon="" ;; # Icono genérico para apps desconocidas
      esac

      # Evitar iconos duplicados en el mismo workspace
      [[ "$icons" != *"$icon"* ]] && icons+="$icon "
    done

    # Formato del workspace
    if [ "$i" -eq "$active" ]; then
      output+="<span color='#bd93f9' weight='bold'> $i $icons</span>"
    else
      if [ -z "$icons" ]; then
        output+="<span color='#6272a4'> $i </span>"
      else
        output+="<span color='#f8f8f2'> $i $icons</span>"
      fi
    fi
  done

  echo "{\"text\": \"$output\"}"
}

# Ejecutar una vez al inicio
generate_output

# Escuchar eventos de Hyprland para actualizar al instante
# Actualiza al abrir, cerrar, mover ventanas o cambiar de workspace
socat -u "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" - | while read -r line; do
  case "$line" in
  workspace* | focusedmon* | openwindow* | closewindow* | movewindow*)
    generate_output
    ;;
  esac
done
