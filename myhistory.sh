#!/bin/bash

# ANSI Renk Kodları
BOLD_WHITE="\033[1;37m"
GREEN="\033[0;32m"
RESET="\033[0m"
YEAR=$(date +"%Y")

# ASCII sanatı (Patorjk Dancing Font 2025)
ASCII_YEAR="
   ______ __     ____   _       __                                      __
  / ____// /    /  _/  | |     / /_____ ____ _ ____   ____   ___   ____/ /
 / /    / /     / /    | | /| / // ___// __  // __ \ / __ \ / _ \ / __  / 
/ /___ / /___ _/ /     | |/ |/ // /   / /_/ // /_/ // /_/ //  __// /_/ /  
\____//_____//___/     |__/|__//_/    \__,_// .___// .___/ \___/ \__,_/   
                                           /_/    /_/ 
"

# Fish Shell kullanılıyor mu kontrol et
if [ -f "$HOME/.local/share/fish/fish_history" ]; then
    HISTORY_FILE="$HOME/.local/share/fish/fish_history"
    # Fish history dosyasında sadece komutları çek
    TOP_COMMANDS=$(awk -F': ' '/- cmd:/ {print $2}' "$HISTORY_FILE" | sort | uniq -c | sort -nr | head -5)
    TOP_INVOCATIONS="$TOP_COMMANDS"
    TOTAL_COMMANDS=$(awk -F': ' '/- cmd:/ {count++} END {print count}' "$HISTORY_FILE")
else
    HISTORY_FILE="$HOME/.bash_history"
    # Bash history için analiz yap
    TOP_COMMANDS=$(awk '{print $1}' "$HISTORY_FILE" | sort | uniq -c | sort -nr | head -5)
    TOP_INVOCATIONS=$(sort "$HISTORY_FILE" | uniq -c | sort -nr | head -5)
    TOTAL_COMMANDS=$(wc -l < "$HISTORY_FILE")
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
    CMD=$(echo "$TOP_COMMANDS" | sed -n "${i}p" | awk '{$1=""; print $0}')
    INVOC=$(echo "$TOP_INVOCATIONS" | sed -n "${i}p" | awk '{$1=""; print $0}')
    printf "${GREEN}%-2s.${RESET} %-17s ${GREEN}%-2s.${RESET} %-30s\n" "$i" "$CMD" "$i" "$INVOC"
done

# Toplam çalıştırılan komutları göster
echo -e "\n${BOLD_WHITE}Commands Ran${RESET}"
echo -e "${GREEN}${TOTAL_COMMANDS}${RESET}"


