# dump1090 Real-Time Signal Statistics

This project provides a web application for real-time monitoring of ADS-B messages using `dump1090`. The application consists of a FastAPI backend and a frontend that displays various statistics in real-time using Chart.js.

## Features

- **Message Rate Statistics**: Computes and displays message rates over different intervals (5s, 15s, 30s, 60s, 300s).
- **Signal Strength Statistics**: Computes and displays minimum, maximum, and average signal strength over 30 seconds.
- **Distance Statistics**: Computes and displays minimum, maximum, and percentile distances over 30 seconds.
- **Coverage Statistics**: Displays coverage statistics in a radar chart, showing the distribution of messages by distance and bearing.

## Backend (main.py)

The backend is built using FastAPI and provides the following functionalities:

- **WebSocket Endpoint**: Handles WebSocket connections to broadcast real-time statistics to the frontend.
- **ADSB Client**: Connects to a `dump1090` BEAST server to receive ADS-B messages, compute statistics, and update sliding windows.
- **Statistics Computation**: Computes message rates, signal strength, distance statistics, and coverage statistics.
- **Broadcast Task**: Periodically computes and broadcasts statistics to all connected WebSocket clients.

### Running the Backend

To run the backend, execute the following command:

```bash
python msgrates.py
```

### Command Line Arguments

The script supports the following command line arguments:

- `--host`: Host to run the web server on (default: `0.0.0.0`).
- `--port`: Port to run the web server on (default: `8000`).
- `--antenna-lat`: Antenna latitude (required for running the server).
- `--antenna-lon`: Antenna longitude (required for running the server).
- `--dump1090-host`: Host running dump1090 (default: `localhost`).
- `--dump1090-port`: Port for dump1090 (default: `30005`).

Example usage:

```bash
python msgrates.py run --antenna-lat 52.5200 --antenna-lon 13.4050
```

### Installation

You can install the program from pip:

```bash
pip install signalstats1090
```

After installation, you can run the program using the following command:

```bash
signalstats1090 run --antenna-lat 52.5200 --antenna-lon 13.4050
```

## Frontend (index.html)

The frontend is an HTML page that uses Chart.js to display various statistics in real-time. It connects to the backend via WebSocket to receive updates and update the charts.

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

## License

This project is licensed under the MIT License.

&copy; 2025 Clemens Vasters. All rights reserved.