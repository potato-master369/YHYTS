#!/bin/bash

# Colour codes
RED='\033[0;31m'
NC='\033[0m'  # NC is for No Colour
GREEN='\033[0;32m'
LIGHTBLUE='\033[1;36m'

# Create logs to waste space cos these logs aren't actually useful
if ! [ -d "$HOME/.local/share/yhyts/logs" ]; then
    mkdir -p $HOME/.local/share/yhyts/logs
fi

if ! [ -e "$HOME/.local/share/yhyts/logs/log.txt" ]; then
    touch $HOME/.local/share/yhyts/logs/log.txt
fi

# Defining as an actual usable script???
if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    echo "YHYTS 1.0.0: literally totally useful definitely legitimate and not just a useless piece of shit, and hopefully its name doesn't take up the entirety of your terminal shell or TTY."
    echo -e "${LIGHTBLUE} Usage: ${NC}yhyts.sh [OPTIONS]"
    echo "    --help, -h      Display this help message"
    echo "    --version, -v   Show the script version"
    echo "    --debug, -d     Show debug messages"
    echo "NOTE: YHYTS automatically ignores unidentifiable options. Only 1 option per execution is permitted."
    echo "Logs are stored in ~/.local/share/yhyts/logs"
    echo "$(date '+%Y-%m-%d %H:%M:%S'), User requested help, exiting with code 0" >> $HOME/.local/share/yhyts/logs/log.txt
    exit 0
fi

if [[ "$1" == "--version" ]] || [[ "$1" == "-v" ]]; then
    echo "YHYTS 1.0.0"
    echo "$(date '+%Y-%m-%d %H:%M:%S'), User requested version, exiting with code 0" >> $HOME/.local/share/yhyts/logs/log.txt
    exit 0
fi

# Stolen from Stack Exchange, credit: Tobias, 2011
echo -e "${LIGHTBLUE}YHYTS 1.0.0 (NO LICENSE)${NC}"

if [[ "$1" == "--debug" ]] || [[ "$1" == "-d" ]]; then
    echo "Printing environment variables..."
    printenv
    echo "$(date '+%Y-%m-%d %H:%M:%S'), User requested debug option" >> $HOME/.local/share/yhyts/log.txt
    echo "$(date '+%Y-%m-%d %H:%M:%S'), DEBUG: Printing environment variables" >> $HOME/.local/share/yhyts/log.txt
fi

read -p "Welcome to YHYTS. Enter your query: " query
echo "$(date '+%Y-%m-%d %H:%M:%S'), User has entered query $query" >> $HOME/.local/share/yhyts/log.txt

echo "YHYTS: Searching YouTube..."
echo "$(date '+%Y-%m-%d %H:%M:%S'), Searching YouTube with yt-dlp" >> $HOME/.local/share/yhyts/log.txt
if [[ "$1" == "--debug" ]] || [[ "$1" == "-d" ]]; then
    echo "Using yt-dlp to print messages using the command yt-dlp ytsearch10:$query --print 'Video %(title)s...'"
fi

results=$(yt-dlp "ytsearch20:$query" --print "Video %(title)s by %(uploader)s, the link is %(webpage_url)s")

if [ -z "$results" ]; then
    echo -e "${RED}No results found.${NC}"
    echo "$(date '+%Y-%m-%d %H:%M:%S'), User's search has no results found." >> $HOME/.local/share/yhyts/log.txt
    exit 1
fi

echo -e "${GREEN}Search Results:${NC}"
echo "$results" | nl -s ") "
echo "$(date '+%Y-%m-%d %H:%M:%S'), Requesting user for file number" >> $HOME/.local/share/yhyts/log.txt
read -p "YHYTS: Enter a number from the above to play: " video

# Extract and play the selected URL
echo "$(date '+%Y-%m-%d %H:%M:%S'), Extracting and playing the URL using sed, awk, and mpv" >> $HOME/.local/share/yhyts/log.txt
if [[ "$1" == "--debug" ]] || [[ "$1" == "-d" ]]; then
    echo "Scanning for result... (Uses sed)"
fi
selectedresult=$(echo "$results" | sed -n "${video}p")
if [[ "$1" == "--debug" ]] || [[ "$1" == "-d" ]]; then
    echo "Extracting URL... (Uses awk)"
fi
video_url=$(echo "$selectedresult" | awk '{print $NF}')

if [[ $video_url =~ ^https?:// ]]; then
    echo "Playing video :p..."
    if [[ "$1" == "--debug" ]] || [[ "$1" == "-d" ]]; then
        echo "Displaying video using mpv with the command mpv \"$video_url\"..."
    fi
    mpv "$video_url"
else
    echo -e "${RED}Invalid selection, please try again.${NC}"
    echo "$(date '+%Y-%m-%d %H:%M:%S'), User's choice is invalid." >> $HOME/.local/share/yhyts/log.txt
    exit 1
fi
