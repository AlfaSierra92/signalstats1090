#!/bin/bash

# Function to install the service
install_service() {
    # Print parameters and ask for confirmation
    echo "The following parameters will be used for installation:"
    echo "Host: $HOST"
    echo "Port: $PORT"
    echo "Antenna Latitude: $ANTENNA_LAT"
    echo "Antenna Longitude: $ANTENNA_LON"
    echo "dump1090 Host: $DUMP1090_HOST"
    echo "dump1090 Port: $DUMP1090_PORT"

    read -p "Do you want to proceed with the installation? (yes/no): " confirmation
    if [[ "$confirmation" != "yes" ]]; then
        echo "Installation aborted."
        exit 0
    fi

    script_dir=$(dirname "$(realpath "$0")")

    # Create user if needed
    if ! id -u signalstats1090 >/dev/null 2>&1; then
        sudo useradd -r -s /usr/sbin/nologin -m signalstats1090
    fi

    # Ensure home directory exists and set permissions
    home_dir="/home/signalstats1090"
    sudo mkdir -p "$home_dir"
    sudo chown -R signalstats1090:signalstats1090 "$home_dir"

    # Create log directory
    log_dir="/var/log/signalstats1090"
    sudo mkdir -p "$log_dir"
    sudo chown -R signalstats1090:signalstats1090 "$log_dir"

    # Create virtual environment
    venv_dir="$home_dir/venv"
    sudo -u signalstats1090 python3 -m venv "$venv_dir"
    # Copy script directory to the service user's home directory
    sudo -u signalstats1090 "$venv_dir/bin/pip" install --upgrade pip
    sudo -u signalstats1090 "$venv_dir/bin/pip" install signalstats1090

    

    # Write systemd unit
    service_path="/etc/systemd/system/signalstats1090.service"
    service_content=$(
        cat <<EOF
[Unit]
Description=signalstats1090 service
After=network.target

[Service]
User=signalstats1090
WorkingDirectory=$home_dir
ExecStart=$venv_dir/bin/signalstats1090 run
Restart=always

[Install]
WantedBy=multi-user.target
EOF
    )
    echo "$service_content" | sudo tee "$service_path" > /dev/null

    # Write config file for the new user
    user_config_file="$home_dir/.signalstats1090.config"
    new_conf=$(
        cat <<EOF
{
    "host": "$HOST",
    "port": $PORT,
    "antenna_lat": $ANTENNA_LAT,
    "antenna_lon": $ANTENNA_LON,
    "dump1090_host": "$DUMP1090_HOST",
    "dump1090_port": $DUMP1090_PORT
}
EOF
    )
    echo "$new_conf" | sudo tee "$user_config_file" > /dev/null
    sudo chown signalstats1090:signalstats1090 "$user_config_file"

    # Reload systemd and enable
    sudo systemctl daemon-reload
    sudo systemctl enable signalstats1090.service

    echo "Service installed. Use 'sudo systemctl start signalstats1090' to run."
}

# Function to uninstall the service
uninstall_service() {
    # Stop and disable the service
    sudo systemctl stop signalstats1090.service
    sudo systemctl disable signalstats1090.service

    # Remove the systemd service file
    service_path="/etc/systemd/system/signalstats1090.service"
    if [[ -f "$service_path" ]]; then
        sudo rm "$service_path"
    fi

    # Reload systemd
    sudo systemctl daemon-reload

    # Optionally, remove the user and log directory
    if id -u signalstats1090 >/dev/null 2>&1; then
        sudo userdel signalstats1090
    fi
    log_dir="/var/log/signalstats1090"
    if [[ -d "$log_dir" ]]; then
        sudo rm -rf "$log_dir"
    fi

    echo "Service uninstalled."
}

# Set defaults

HOST="localhost"
PORT=8000
DUMP1090_HOST="localhost"
DUMP1090_PORT=30005

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --host) HOST="$2"; shift ;;
        --port) PORT="$2"; shift ;;
        --antenna-lat) ANTENNA_LAT="$2"; shift ;;
        --antenna-lon) ANTENNA_LON="$2"; shift ;;
        --dump1090-host) DUMP1090_HOST="$2"; shift ;;
        --dump1090-port) DUMP1090_PORT="$2"; shift ;;
        install) ACTION="install" ;;
        uninstall) ACTION="uninstall" ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

case "$ACTION" in
    install)
        # Check if required parameters are set
        if [[ -z "$ANTENNA_LAT" || -z "$ANTENNA_LON" ]]; then
            echo "Antenna latitude and longitude are required."
            exit 1
        fi
        install_service
        ;;
    uninstall)
        uninstall_service
        ;;
    *)
        echo "Usage: $0 {install|uninstall} --host <host> --port <port> --antenna-lat <antenna_lat> --antenna-lon <antenna_lon> --dump1090-host <dump1090_host> --dump1090-port <dump1090_port>"
        echo "  install --host <host> --port <port> --antenna-lat <antenna_lat> --antenna-lon <antenna_lon> --dump1090-host <dump1090_host> --dump1090-port <dump1090_port>"
        echo "  uninstall"
        exit 1
        ;;
esac