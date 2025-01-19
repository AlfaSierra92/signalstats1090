# dump1090 Real-Time Signal Statistics

This project provides a web application for real-time monitoring of ADS-B messages using `dump1090`. The application consists of a FastAPI backend and a frontend that displays various statistics in real-time using Chart.js.

## Features

- **Message Rate Statistics**: Computes and displays message rates over
  different intervals (5s, 15s, 30s, 60s, 300s).
- **Signal Strength Statistics**: Computes and displays minimum, maximum, and
  average signal strength over 30 seconds.
- **Distance Statistics**: Computes and displays minimum, maximum, and
  percentile distances over 30 seconds.
- **Coverage Statistics**: Displays coverage statistics in a radar chart,
  showing the distribution of messages by distance and bearing.

## Installation

### Prerequisites

- Python 3.6+
- `dump1090` running on the same machine or accessible via network.

### Installation

You can install the application using `pip`:

```bash
pip install signalstats1090
```

This will install the `signalstats1090` command-line tool, which you can use to run the backend server.

If you want to run the application as a service, you can use the provided setup script explained below.

### Running the app

To run the app, execute the following command:

```bash
signalstats1090 run --antenna-lat <antenna_lat> --antenna-lon <antenna_lon>
```

The `--antenna-lat` and `--antenna-lon` arguments are required. You can find the
latitude and longitude of your antenna using Google Maps or similar services.

```bash

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

```bash
wget -qO- https://raw.githubusercontent.com/clemensv/signalstats1090/main/setup.sh > ~/signalstats1090_setup.sh
chmod +x ~/signalstats1090_setup.sh
```

Then run the setup script with the required arguments:

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

### Charts

- **Message Rate Chart**: Displays message rates over different intervals (5s, 15s, 30s, 60s, 300s).
- **Signal Strength Chart**: Displays minimum, average, and maximum signal strength over 30 seconds.
- **Distance Chart**: Displays minimum, maximum, and percentile distances over 30 seconds.
- **Distance Histogram Chart**: Displays the count of position readings in 30km buckets (up to 300km).
- **Coverage Chart**: Displays coverage statistics in a radar chart, showing the distribution of messages by distance and bearing.

### Viewing the Frontend

To view the frontend, open a web browser and navigate to:

```
http://localhost:8000
```

or whatever host and port you specified when running the server.

## License

This project is licensed under the MIT License.

&copy; 2025 Clemens Vasters. All rights reserved.