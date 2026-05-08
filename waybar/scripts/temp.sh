#!/bin/bash

# CPU (hwmon2)
cpu=$(cat /sys/class/hwmon/hwmon2/temp1_input 2>/dev/null | awk '{print $1/1000}')

# GPU (amdgpu suele ser hwmon0 o hwmon1, busquémoslo por nombre)
gpu_path=$(grep -l "amdgpu" /sys/class/hwmon/hwmon*/name | sed 's/name/temp1_input/')
gpu=$(cat $gpu_path 2>/dev/null | awk '{print $1/1000}')

# NVMe (lo mismo)
nvme_path=$(grep -l "nvme" /sys/class/hwmon/hwmon*/name | sed 's/name/temp1_input/')
nvme=$(cat $nvme_path 2>/dev/null | awk '{print $1/1000}')

# Definir la clase según la temperatura de la CPU
class="normal"
if [ "${cpu%.*}" -ge 80 ]; then
  class="critical"
elif [ "${cpu%.*}" -ge 65 ]; then
  class="warning"
fi

# Formato JSON con el campo "class"
echo "{\"text\": \" ${cpu%.*}°C\", \"tooltip\": \"󰻠 CPU: ${cpu%.*}°C\n󰢮 GPU: ${gpu%.*}°C\n󱛟 SSD: ${nvme%.*}°C\", \"class\": \"$class\"}"
