#!/bin/bash

green='\e[1;32m'
red='\e[1;31m'
yellow='\e[1;33m'
reset='\e[0m'

# رنگ‌های رنگین‌کمانی
colors=('\e[1;31m' '\e[1;33m' '\e[1;32m' '\e[1;36m' '\e[1;34m' '\e[1;35m')

# تابع رنگین‌کمانی aparat
rainbow() {
    text="aparat : parham008 /ERROR 404 "
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

# 🔍 تابع اسکن IP (گزینه 3)
scan_ip() {
    echo ""
    echo "🔍 Scanning for clean IPs (ping < 150ms)..."
    echo ""

    clean_found=false

    while [ "$clean_found" = false ]; do
        
        ip="$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))"
        echo "Testing: $ip"

        ping_output=$(ping -c 1 -W 2 $ip 2>/dev/null)

        if [ $? -eq 0 ]; then
            ms=$(echo "$ping_output" | grep -oP 'time=\K[0-9\.]+')

            if [ -n "$ms" ]; then
                echo "Ping: ${ms}ms"

                ms_int=${ms%.*}

                if [ "$ms_int" -lt 150 ]; then
                    echo -e "${green}✔ CLEAN IP FOUND: $ip (${ms}ms)${reset}"
                    clean_found=true
                    final_ip="$ip"
                else
                    echo -e "${red}❌ Not clean (${ms_int}ms)${reset}"
                fi
            else
                echo "✖ No ms detected"
            fi

        else
            echo "✖ No response"
        fi

        echo "---------------------"
    done

    echo ""
    echo "===== FINAL CLEAN IP ====="
    echo "$final_ip"

    echo ""
    read -p "1) continue" back
}

# ================= حلقه اصلی =================

while true; do
    clear
    rainbow
    echo -e "${yellow}Select :${reset}"
    echo -e "${yellow}1) V2Ray config${reset}"
    echo -e "${yellow}2) Proxy Telegram${reset}"
    echo -e "${yellow}3) Scan IPv4 (clean IP)${reset}"
    echo -e "${yellow}4) Exit${reset}"
    echo ""
    read -p "Enter number: " num

    # گزینه ۴ → خروج کامل
    if [ "$num" = "4" ]; then
        echo -e "${red}Exiting...${reset}"
        exit 0
    fi

    # گزینه ۳ → اسکن IP
    if [ "$num" = "3" ]; then
        scan_ip
        continue
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
