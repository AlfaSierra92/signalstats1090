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