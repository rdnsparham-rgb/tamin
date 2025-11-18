#!/bin/bash

green='\e[1;32m'
red='\e[1;31m'
yellow='\e[1;33m'
reset='\e[0m'

# رنگ‌های رنگین‌کمانی
colors=('\e[1;31m' '\e[1;33m' '\e[1;32m' '\e[1;36m' '\e[1;34m' '\e[1;35m')

# تابع رنگین‌کمانی aparat
rainbow() {
    text="aparat : parham008 ERROR 404 "
    len=${#text}
    for ((i=0; i<$len; i++)); do
        c=${text:$i:1}
        color=${colors[$((i % ${#colors[@]}))]}
        echo -ne "${color}${c}${reset}"
    done
    echo ""
}

# تابع تست پینگ
check_ping() {
    ip=$1
    ping -c 1 -W 1 "$ip" &>/dev/null
    return $?
}

# حلقه اصلی
while true; do
    clear
    rainbow
    echo -e "${yellow}Select :${reset}"
    echo -e "${yellow}1) v2ray config${reset}"
    echo -e "${yellow}2) proxy telegram${reset}"
    echo -e "${yellow}3) Exit${reset}"
    echo ""
    read -p "Enter number: " num

    # گزینه 3 → خروج کامل
    if [ "$num" = "3" ]; then
        echo -e "${red}Exiting...${reset}"
        exit 0
    fi

    # ------------------ گزینه ۱ (V2Ray) ------------------
    if [ "$num" = "1" ]; then
        echo "Create config v2ray ..."
        list=$(curl -s https://raw.githubusercontent.com/rdnsparham-rgb/tamin/refs/heads/main/v2ray.txt)

        while true; do
            config=$(echo "$list" | shuf -n 1)

            ip=$(echo "$config" | sed -n 's/.*@\(.*\):.*/\1/p')

            echo "Testing $ip ..."
            if check_ping "$ip"; then
                echo -e "${green}$config${reset}"
                break
            else
                echo -e "${red}Ping failed. Trying another...${reset}"
            fi
        done

        echo ""
        read -p "1) continue" back
        continue
    fi

    # ------------------ گزینه ۲ (Proxy) ------------------
    if [ "$num" = "2" ]; then
        echo "Create proxy telegram ..."
        list=$(curl -s https://raw.githubusercontent.com/rdnsparham-rgb/tamin/refs/heads/main/proxy.txt)

        while true; do
            proxy=$(echo "$list" | shuf -n 1)

            ip=$(echo "$proxy" | sed -n 's/.*server=\(.*\)&port.*/\1/p')

            echo "Testing $ip ..."
            if check_ping "$ip"; then
                echo -e "${green}$proxy${reset}"
                break
            else
                echo -e "${red}Ping failed. Trying another...${reset}"
            fi
        done

        echo ""
        read -p "1) continue" back
        continue
    fi

    # اگر عدد اشتباه بود
    echo -e "${red}Wrong number! Try again...${reset}"
    sleep 1
done
