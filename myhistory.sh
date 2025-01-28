#!/bin/bash

# ANSI Renk Kodları
BOLD_WHITE="\033[1;37m"
GREEN="\033[0;32m"
RESET="\033[0m"
YEAR=$(date +"%Y")

# ASCII sanatı (Patorjk Dancing Font 2025)
ASCII_YEAR="
   _____  _       _____  __          __                                   _ 
  / ____|| |     |_   _| \ \        / /                                  | |
 | |     | |       | |    \ \  /\  / /_ __  __ _  _ __   _ __    ___   __| |
 | |     | |       | |     \ \/  \/ /|  __|/ _  ||  _ \ |  _ \  / _ \ / _  |
 | |____ | |____  _| |_     \  /\  / | |  | (_| || |_) || |_) ||  __/| (_| |
  \_____||______||_____|     \/  \/  |_|   \__,_|| .__/ | .__/  \___| \__,_|
                                                 | |    | |                 
                                                 |_|    |_|                 
"

# Fish Shell kullanılıyor mu kontrol et
if [ -f "$HOME/.local/share/fish/fish_history" ]; then
    HISTORY_FILE="$HOME/.local/share/fish/fish_history"
    # Fish history formatını düzleştirip sadece komutları al
    TOP_COMMANDS=$(grep -oP "(?<=- cmd: ).*" "$HISTORY_FILE" | sort | uniq -c | sort -nr | head -5)
    TOP_INVOCATIONS=$(grep -oP "(?<=- cmd: ).*" "$HISTORY_FILE" | sort | uniq -c | sort -nr | head -5)
    TOTAL_COMMANDS=$(grep -c "- cmd:" "$HISTORY_FILE")
else
    HISTORY_FILE="$HOME/.bash_history"
    # Bash history için analiz yap
    TOP_COMMANDS=$(cat "$HISTORY_FILE" | awk '{print $1}' | sort | uniq -c | sort -nr | head -5)
    TOP_INVOCATIONS=$(cat "$HISTORY_FILE" | sort | uniq -c | sort -nr | head -5)
    TOTAL_COMMANDS=$(cat "$HISTORY_FILE" | wc -l)
fi

# Çıktıyı temizle
clear

# Başlık
echo -e "${BOLD_WHITE}"
echo -e "$YEAR"
echo -e "${RESET}"
echo -e "$ASCII_YEAR"

# Başlıkları yazdır
printf "%-20s %-30s\n" "Top Commands" "Top Invocations"
printf "%-20s %-30s\n" "----------------" "----------------"

# İlk 5 komutu ve invocation'ı yan yana yazdır
for i in {1..5}; do
    CMD=$(echo "$TOP_COMMANDS" | sed -n "${i}p" | awk '{print $2}')
    INVOC=$(echo "$TOP_INVOCATIONS" | sed -n "${i}p" | awk '{print substr($0, index($0,$2))}')
    printf "${GREEN}%-2s.${RESET} %-17s ${GREEN}%-2s.${RESET} %-30s\n" "$i" "$CMD" "$i" "$INVOC"
done

# Toplam çalıştırılan komutları göster
echo -e "\n${BOLD_WHITE}Commands Ran${RESET}"
echo -e "${GREEN}${TOTAL_COMMANDS}${RESET}"
