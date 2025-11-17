#!/bin/bash

# رنگ‌ها
green='\e[1;32m'
reset='\e[0m'

clear
echo -e "aparat : parham008"
echo ""
echo "Select :"
echo "1) v2ray config"
echo "2) proxy telegram"
echo ""
read -p "Enter number: " num

if [ "$num" = "1" ]; then
    echo "Getting a random V2Ray config..."
    sleep 2

    # دانلود لیست
    list=$(curl -s https://raw.githubusercontent.com/rdnsparham-rgb/tamin/refs/heads/main/v2ray.txt)

    # گرفتن یک کانفیگ رندوم
    config=$(echo "$list" | shuf -n 1)

    echo -e "${green}$config${reset}"
fi

if [ "$num" = "2" ]; then
    echo "Getting a random Telegram proxy..."
    sleep 2

    # دانلود پروکسی‌ها
    list=$(curl -s https://raw.githubusercontent.com/rdnsparham-rgb/tamin/refs/heads/main/proxy.txt)

    # انتخاب رندوم
    proxy=$(echo "$list" | shuf -n 1)

    echo -e "${green}$proxy${reset}"
fi
