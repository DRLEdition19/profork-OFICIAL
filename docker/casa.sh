#!/bin/bash

echo "Profork CasaOS installer..."
echo "This can take a while... please wait....."
echo "Note: Github file hosting can be slow/unreliable - Try again if download fails"
sleep 5

# Define the home directory
HOME_DIR=/userdata/system


PART_BASE_URL="https://github.com/trashbus99/profork/releases/download/r1/batocera-casaos.part."
PART_COUNT=4

# Change to home directory
cd "${HOME_DIR}"
if [ $? -ne 0 ]; then
    echo "Failed to change to home directory. Exiting."
    exit 1
fi

# Remove any existing files
rm -f batocera-casaos.part.*

# Retry count
RETRIES=5

# Function to download file with progress and retry logic
download_with_retry() {
    local url="$1"
    local output="$2"
    local retries=0

    until [ $retries -ge $RETRIES ]
    do
        curl -L --progress-bar --retry 3 --retry-delay 5 --retry-max-time 30 -o "${output}" "${url}"
        if [ $? -eq 0 ]; then
            echo "Downloaded ${output} successfully."
            return 0
        else
            retries=$((retries+1))
            echo "Retrying... (${retries}/${RETRIES})"
        fi
    done

    echo "Failed to download ${output} after ${RETRIES} attempts. Exiting."
    exit 1
}

# Download the files
echo "Downloading 4 split parts..."
for i in $(seq 0 $((PART_COUNT - 1)))
do
    part_number=$(printf "%d" $i)  # Ensures numeric suffix without leading zeros
    part_file="batocera-casaos.part.${part_number}"
    download_with_retry "${PART_BASE_URL}${part_number}" "${part_file}"
done

# Combine the split parts
echo "Combining split parts..."
cat batocera-casaos.part.* > batocera-casaos.tar.gz
if [ $? -ne 0 ]; then
    echo "Failed to combine the split parts. Exiting."
    exit 1
fi

# Extract the tar.gz file
echo "Extracting the tar.gz file..."
tar -xzvf "batocera-casaos.tar.gz"
if [ $? -ne 0 ]; then
    echo "Failed to extract the tar.gz file. Exiting."
    exit 1
fi

echo "Process completed successfully."








 
# Clean up zip and tar files
rm batocera-casaos.tar.zip*
rm batocera-casaos.tar.gz

# Download the executable using aria2c
echo "Downloading the executable file..."

# Function to download the executable file with retry and progress bar
download_executable_with_retry() {
    local url="$1"
    local output="$2"
    local retries=0

    until [ $retries -ge $RETRIES ]
    do
        curl -L --progress-bar --retry 3 --retry-delay 5 --retry-max-time 30 -o "${output}" "${url}"
        if [ $? -eq 0 ]; then
            echo "Downloaded ${output} successfully."
            return 0
        else
            retries=$((retries+1))
            echo "Retrying... (${retries}/${RETRIES})"
        fi
    done

    echo "Failed to download ${output} after ${RETRIES} attempts. Exiting."
    exit 1
}

# Download the executable file
download_executable_with_retry "https://github.com/trashbus99/profork/releases/download/r1/batocera-casaos" "casaos/batocera-casaos"



# Make the executable runnable
chmod +x "/userdata/system/casaos/batocera-casaos"
if [ $? -ne 0 ]; then
    echo "Failed to make the file executable. Exiting."
    exit 1
fi

# Add casa to custom.sh for autostart
echo "/userdata/system/casaos/batocera-casaos &" >> ~/custom.sh

# Run the executable
echo "Running the executable..."
"${HOME_DIR}/casaos/batocera-casaos"
if [ $? -ne 0 ]; then
    echo "Failed to run the executable. Exiting."
    exit 1
fi

rm aria2c

# Final dialog message with casaos management info
MSG="Casaos container has been set up.\n\nAccess casa Web UI at http://<your-batocera-ip>:80 \n\nRDP Debian XFCE Desktop port 3389 username/password is root/linux\n\nCasaos data stored in: ~/casaos\n\nDefault web ui username/password is batocera/batoceralinux"
dialog --title "Casaos Setup Complete" --msgbox "$MSG" 20 70

echo "Process completed successfully."

echo "1) to stop the container, run:  podman stop casaos"
echo "2) to enter zsh session, run:  podman exec -it casaos zsh"
