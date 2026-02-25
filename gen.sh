#!/bin/bash

echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "~~~Welcome to the log search generator~~~"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

#Asks users for the absolute file paths and stores them in an array

DESTINATIONS=()
DEST_COUNT=0

echo -e "\nPlease input the absolute paths of the file/s you want analyzed."
echo -e "\nWhen finished, type exactly: DONE"

while true
do
	if [ "$DEST_COUNT" -ne 0 ];then
		echo -e "\nInput the next file's path or type DONE to proceed."
	fi
	read DEST_NAME
	if [[ "$DEST_NAME" != "DONE" ]] && [[ ! -f "$DEST_NAME" || ! -r "$DEST_NAME" ]]; then
		echo -e "\nError. Insufficient read permissions or the file doesn't exist"
		echo "Exiting..."
		exit 1
	fi

	if [ "$DEST_NAME" == "DONE" ]; then
		break
	else
		DESTINATIONS+=("$DEST_NAME")
		((DEST_COUNT++))
	fi
done

if [ "$DEST_COUNT" -eq 0 ]; then
	echo -e "\nThe program needs at least one file path to continue."
	echo "Exiting..."
	exit 1
fi

#Asks users for the search keywords and stores them in an array

KEYWORDS=()
KEY_COUNT=0

echo -e "\nPlease input the keyword/s to search for in your files."
echo -e "\nWhen finished type exactly: DONE"

while true
do
	if [ "$KEY_COUNT" -ne 0 ];then
		echo -e "\nInput the next search keyword or type DONE to proceed."
	fi
	read KEY_NAME

	if [ "$KEY_NAME" == "DONE" ]; then
		break
	else
		KEYWORDS+=("$KEY_NAME")
		((KEY_COUNT++))
	fi
done

if [ "$KEY_COUNT" -eq 0 ]; then
	echo -e "\nThe program needs atleast one search keyword to continue."
	echo "Exiting..."
	exit 1
fi


#Ask the user if he wants the output to be saved to a file or displayed on the terminal.

while true; do
	echo -e "\nWould you like to save the output or read it on the terminal? (SAVE/READ)" 
	read SAVE_CHOICE
	
	if [ "$SAVE_CHOICE" == "SAVE" ] || [ "$SAVE_CHOICE" == "READ" ]; then
		break
	fi
	
done



#Ask the user to specify a location to save the final script file
if [ "$SAVE_CHOICE" == "SAVE" ]; then 
	echo -e "\nPlease specify the absolute path of the directory where you want the log to be saved to."
	read SAVE_PATH

#Check if the path is valid and writable
	if [[ ! -d "$SAVE_PATH" || ! -w "$SAVE_PATH" ]]; then
		echo -e "\nError. Directory does not exist or write permissions are not assigned"
		echo -e "Exiting..."
		exit 1
	fi	

	LAST_CHAR="${SAVE_PATH: -1}"
	if [ "$LAST_CHAR" == "/" ]; then
		SAVE_PATH="${SAVE_PATH%/}"
	fi
fi



#Generate the file path of the log file. Use timestamps to avoid overwrites.
NOW="$(date +'%Y-%m-%d_%H_%M_%S')"
FINAL_FILE=""$SAVE_PATH"/log_result_"$NOW".txt"

#Generate the logs using the user provided parameters.

#If the user wanted to display the output on the terminal, execute the following code.

if [ "$SAVE_CHOICE" == "READ" ]; then
	echo -e "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	echo -e "Logs generated at "$NOW"."
	echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
	for LOG in "${DESTINATIONS[@]}"; do
		for kw in "${KEYWORDS[@]}"; do
			MATCH_COUNT="$(grep -c "$kw" "$LOG")"
			if [ "$MATCH_COUNT" -gt 0 ]; then
				echo -e "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
				echo -e "Logs generated with "$LOG" file using "$kw" keyword."
				echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n"
				grep "$kw" "$LOG"
			else
				echo -e "\nNo logs were found in "$LOG" with "$kw" keyword"
			fi
		done
	done

#If the user wanted to save the output, execute the following code

elif [ "$SAVE_CHOICE" == "SAVE" ]; then
	touch "$FINAL_FILE"
	echo -e "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >> "$FINAL_FILE"
	echo -e "Logs generated at "$NOW"." >> "$FINAL_FILE"
	echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >> "$FINAL_FILE"
	for LOG in "${DESTINATIONS[@]}"; do
		for kw in "${KEYWORDS[@]}"; do
			MATCH_COUNT="$(grep -c "$kw" "$LOG")"
			if [ "$MATCH_COUNT" -gt 0 ]; then
				echo -e "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" >> "$FINAL_FILE"
				echo -e "Logs generated with "$LOG" file using "$kw" keyword.">> "$FINAL_FILE"
				echo -e "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n">> "$FINAL_FILE"
				grep "$kw" "$LOG">> "$FINAL_FILE"
			else
				echo -e "\nNo logs were found in "$LOG" with "$kw" keyword">> "$FINAL_FILE"
			fi
		done
	done
	echo -e "\nLog files successfully generated. The file is saved at "$FINAL_FILE""
fi
