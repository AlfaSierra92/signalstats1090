# dump1090 Real-Time Signal Statistics

This project provides a web application for real-time monitoring of ADS-B messages using `dump1090` to help you with optimizing reception performance. The application computes and displays message rates, signal strength, distance statistics, and coverage statistics. It also provides a radar chart showing the distribution of messages by distance and bearing.

## How to use the dashboard

Once you've installed the dashboard application, you can access it by opening a web browser and navigating to the URL where the application is running. The default URL is `http://localhost:8000`.

You can then tune the gain of your receiver to optimize the reception
performance. The goal is to maximize the number of messages received while
keeping the signal strength within a reasonable range. The radar chart shows the
distribution of messages by distance and bearing, which can help you identify
areas with poor reception.
[`dump109-fa`](https://github.com/flightaware/dump1090/blob/master/README.adaptive-gain.md)
provides a built-in feature to adjust the gain automatically, but you can also
adjust it manually based on the statistics provided by the dashboard. Also try setting the gain to zero. Once you've modified the gain, restart dump1090 to apply the changes and
then observe the statistics on the dashboard. Automatic gain adjustment can take several minutes to stabilize, so be patient.

## Features

- **Message Rate Statistics**: Computes and displays message rates over different intervals (5s, 15s, 30s, 60s, 300s).
- **Signal Strength Statistics**: Computes and displays minimum, maximum, and average signal strength over 30 seconds.
- **Distance Statistics**: Computes and displays minimum, maximum, and percentile distances over 30 seconds.
- **Coverage Statistics**: Displays coverage statistics in a radar chart, showing the distribution of messages by distance and bearing.
- **RSSI/Distance Ratio**: Displays the ratio of RSSI to distance for each bearing segment.

![Screenshot](media/screenshot.jpeg)

## Quick Start

### Prerequisites

- `dump1090` running on the same machine or accessible via network.
- Python 3.10+ installed on your machine. Note: Raspbian typically comes with
  Python pre-installed.
- Find out the latitude and longitude of your antenna. You can use Google Maps
  or similar services to find this information. Mode-S/ADS-B messages only contain
  partial position information, so the application needs the antenna location to
  compute the geo-coordinates of aircraft.

### Installation

1. **Install Python**: If you don't have Python installed, download and install it from [python.org](https://www.python.org/downloads/). Raspbian typically comes with Python pre-installed.

> **Note**: If you want to run the application as a service, which is recommended, follow the instructions in the [Installation as a Service](#installation-as-a-service) section.

2. **Install the application**: Open a terminal or command prompt and run:

    ```bash
    pip install signalstats1090
    ```

    This will install the `signalstats1090` command-line tool, which you can use to run the backend server.

    On Raspberry Pi, you should install the package into a virtual environment to avoid conflicts with system packages:

    ```bash
    python3 -m venv signalstats1090
    source signalstats1090/bin/activate
    pip install signalstats1090
    ```  

3. **Run the application**: 
  
   Execute the following command:

    ```bash
    signalstats1090 run --antenna-lat <antenna_lat> --antenna-lon <antenna_lon>
    ```

    (If you use the virtual environment, make sure to activate it first using the `source signalstats1090/bin/activate` command.)

    The `--antenna-lat` and `--antenna-lon` arguments are required. You can find the latitude and longitude of your antenna using Google Maps or similar services.

    If you are running `dump1090` on a different host or port, you can specify the `--dump1090-host` and `--dump1090-port` arguments.

    ```bash
    signalstats1090 run --antenna-lat <antenna_lat> --antenna-lon <antenna_lon> --dump1090-host <dump1090_host> --dump1090-port <dump1090_port>
    ```

    If you need to run the web server on a different host or port, you can
    specify the `--host` and `--port` arguments. The default host is `0.0.0.0`
    which listens on all interfaces.

    ```bash
    signalstats1090 run --host <host> --port <port> --antenna-lat <antenna_lat> --antenna-lon <antenna_lon> --dump1090-host <dump1090_host> --dump1090-port <dump1090_port>
    ```

### Command Line Arguments

The script supports the following command line arguments:

- `--host`: Host to run the web server on (default: `0.0.0.0`).
- `--port`: Port to run the web server on (default: `8000`).
- `--antenna-lat`: Antenna latitude (required for running the server).
- `--antenna-lon`: Antenna longitude (required for running the server).
- `--dump1090-host`: Host running dump1090 (default: `localhost`).
- `--dump1090-port`: Port for dump1090 (default: `30005`).

### Installation as a Service

You can install the program as a service using the provided setup script:

1. **Download the setup script**:

    ```bash
    wget -qO- https://raw.githubusercontent.com/clemensv/signalstats1090/main/setup.sh > ~/signalstats1090_setup.sh
    chmod +x ~/signalstats1090_setup.sh
    ```

2. **Run the setup script with the required arguments**:

    ```bash
    ~/signalstats1090_setup.sh install --host <host> --port <port> --antenna-lat <antenna_lat> --antenna-lon <antenna_lon> --dump1090-host <dump1090_host> --dump1090-port <dump1090_port>
    ```

    The `--antenna-lat` and `--antenna-lon` arguments are required.

#### Arguments for the setup script

- `--host`: Host to run the web server on (default: `0.0.0.0`).
- `--port`: Port to run the web server on (default: `8000`).
- `--antenna-lat`: Latitude of the antenna (required).
- `--antenna-lon`: Longitude of the antenna (required).
- `--dump1090-host`: Host running dump1090 (default: `localhost`).
- `--dump1090-port`: Port for dump1090 (default: `30005`).

### Updating the Service

To update the service to the latest version, run the setup script with the `update` option:

```bash
~/signalstats1090_setup.sh update
```

This will upgrade the package to the latest version in the service account context and restart the service.

### Charts

- **Message Rate Chart**: Displays message rates over different intervals (5s, 15s, 30s, 60s, 300s).
- **Signal Strength Chart**: Displays minimum, average, and maximum signal strength over 30 seconds.
- **Distance Chart**: Displays minimum, maximum, and percentile distances over 30 seconds.
- **Distance Histogram Chart**: Displays the count of position readings in 30km buckets (up to 300km).
- **Coverage Chart**: Displays coverage statistics in a radar chart, showing the distribution of messages by distance and bearing.
- **RSSI/Distance Ratio Chart**: Displays the ratio of RSSI to distance for each bearing segment.

### Viewing the Frontend

To view the frontend, open a web browser and navigate to:

```
http://localhost:8000
```

or whatever host and port you specified when running the server.

## License

This project is licensed under the MIT License.

&copy; 2025 Clemens Vasters. All rights reserved.