# dump1090 Real-Time Signal Statistics (signalstats1090)

[![PyPI](https://img.shields.io/pypi/v/signalstats1090)](https://pypi.org/project/signalstats1090/)
[![PyPI - Python Version](https://img.shields.io/pypi/pyversions/signalstats1090)](https://pypi.org/project/signalstats1090/)
[![PyPI - License](https://img.shields.io/pypi/l/signalstats1090)](https://github.com/clemensv/signalstats1090/blob/main/LICENSE.md)

This project provides a web application for real-time monitoring of ADS-B
messages using `dump1090` to help you with optimizing reception performance. The
application computes and displays message rates, signal strength, distance
statistics, and coverage statistics. It also provides a radar chart showing the
distribution of messages by distance and bearing.

## How to use the dashboard

Once you've installed the dashboard application, you can access it by opening a
web browser and navigating to the URL where the application is running. The
default URL is `http://localhost:8000` if you are running the application on the
local machine. If you are running the application on a different machine,
replace `localhost` with the IP address or hostname of the machine where the
application is running, e.g. `http://mypiaware:8000`.

Using the dashboard you can tune the gain of your receiver to optimize the
reception performance. The goal is to maximize the number of messages received
while keeping the signal strength within a reasonable range. The radar chart
shows the distribution of messages by distance and bearing, which can help you
identify areas with poor reception.
[`dump109-fa`](https://github.com/flightaware/dump1090/blob/master/README.adaptive-gain.md)
provides a built-in feature to adjust the gain automatically, but you can also
adjust it manually based on the statistics provided by the dashboard. Also try
setting the gain to zero. Once you've modified the gain, restart dump1090 to
apply the changes and then observe the statistics on the dashboard. Automatic
gain adjustment can take several minutes to stabilize, so be patient.

## Features

- **Message Rate Statistics**: Computes and displays message rates over
  different intervals (5s, 15s, 30s, 60s, 300s).
- **Signal Strength Statistics**: Computes and displays minimum, maximum, and
  average signal strength over 30 seconds.
- **Distance Statistics**: Computes and displays minimum, maximum, and
  percentile distances over 30 seconds.
- **Coverage Statistics**: Displays coverage statistics in a radar chart,
  showing the distribution of messages by distance and bearing.
- **RSSI/Distance Ratio**: Displays the ratio of RSSI to distance for each
  bearing segment.

![Screenshot](https://github.com/clemensv/signalstats1090/blob/main/media/screenshot.jpeg?raw=true)

## Getting Started

### Prerequisites

- `dump1090` running on the same machine or accessible via network.
- Python 3.10+ installed on your machine. Note: Raspbian typically comes with
  Python pre-installed. Also ensure that support for `venv` is installed (`sudo
  apt-get install python3-venv`).
- Find out the latitude and longitude of your antenna. You can use Google Maps
  or similar services to find this information. Mode-S/ADS-B messages only
  contain partial position information, so the application needs the antenna
  location to compute the geo-coordinates of aircraft.

### Installation

The app can be run on the same Raspberry Pi that runs `dump1090` or on a
different machine. If you are running `dump1090` on a different machine, you
need to specify the host and port of the `dump1090` server when running the
application.

There are three described options to install and run the application:

- [Raspberry Pi Installation (as a service)](#raspberry-pi-installation-as-a-service)
- [Raspberry Pi Installation (as an app)](#raspberry-pi-installation-as-an-app)
- [Installation elsewhere](#installation-elsewhere)

#### Raspberry Pi Installation (as a service)

To install and run the application as a service on Raspberry Pi, you can use the
provided setup script. First, ensure that the the [Prequisites](#prerequisites)
are met. Then follow the steps below:

##### 1. Download the setup script

```bash
wget -qO- https://raw.githubusercontent.com/clemensv/signalstats1090/main/setup.sh > ~/signalstats1090_setup.sh
chmod +x ~/signalstats1090_setup.sh
```

##### 2. Install and start the service

Call the script with the required arguments and any optional arguments you want
to set. The script will install the package and create a systemd service that
starts the web server automatically at boot.

```bash
~/signalstats1090_setup.sh install --antenna-lat <antenna_lat> --antenna-lon <antenna_lon>
```
Replace <antenna_lat> and <antenna_lon> with the coordinates of your receiver.  
If dump1090 is running on a remote host, adjust the --dump1090-host and --dump1090-port as needed.  
The script creates a systemd service that starts automatically at boot.

All arguments for the setup script

- `--host`: Host to run the web server on (default: `0.0.0.0`).
- `--port`: Port to run the web server on (default: `8000`).
- `--antenna-lat`: Latitude of the antenna (required).
- `--antenna-lon`: Longitude of the antenna (required).
- `--dump1090-host`: Host running dump1090 (default: `localhost`).
- `--dump1090-port`: Port for dump1090 (default: `30005`).

##### 3. Start the service

After the installation, you can start the service and verify that it's running
using the following commands:

```bash
sudo systemctl start signalstats1090
sudo systemctl status signalstats1090
```

##### 4. Access the dashboard

Open a web browser and navigate to the URL where the application is running. The
default URL is `http://localhost:8000` if you are running the application on the
local machine. If you are running the application on a different machine, replace
`localhost` with the IP address or hostname of the machine where the application
is running, e.g. `http://mypiaware:8000`.

##### 5. Update or uninstall the service

You can always update the service package to the latest version by running:

```bash
~/signalstats1090_setup.sh update
```

To uninstall the service, run:

```bash
~/signalstats1090_setup.sh uninstall
```

#### Raspberry Pi Installation (as an app)

On Raspberry Pi, ensure Python 3 is installed (usually pre-installed on
Raspbian). Then create a virtual environment in your home directory and install
the package into it:

```bash
sudo apt-get update
sudo apt-get install python3-venv
python3 -m venv ~/signalstats1090
source ~/signalstats1090/bin/activate
pip install signalstats1090
```

Once installed, you can run the application using:

```bash
signalstats1090 run --antenna-lat <antenna_lat> --antenna-lon <antenna_lon>
```

The app supports the following commands and options:

Commands:
- `run`: Run the web server.
- `config`: Set default values for command line arguments for the `run` command.

Options: 

- `--host`: Host to run the web server on (default: `0.0.0.0`).
- `--port`: Port to run the web server on (default: `8000`).
- `--antenna-lat`: Antenna latitude (required for running the server).
- `--antenna-lon`: Antenna longitude (required for running the server).
- `--dump1090-host`: Host running dump1090 (default: `localhost`).
- `--dump1090-port`: Port for dump1090 (default: `30005`).

With the `config` command, you can permanently set the default values for the
command line arguments. This way, you don't have to specify them every time you
`run` the application:

```bash
signalstats1090 config --antenna-lat <antenna_lat> --antenna-lon <antenna_lon>
```

Then you can run the application without specifying the `--antenna-lat` and
`--antenna-lon` arguments:

```bash
signalstats1090 run
```

When starting a new session, activate the virtual environment again before
running the app.

```bash
source ~/signalstats1090/bin/activate
```

To uninstall the application, simply remove the directory:

```bash
rm -rf ~/signalstats1090
```

#### Installation Elsewhere

If you want to run the application on a Mac or PC or anywhere else you
have Python installed, you can follow these steps:

##### 1. Install the package
  
With all the [Prequisites](#prerequisites) met, you can install the package
using:

```bash
pip install signalstats1090
```

If you cloned the Git repository, and you want to play around with the code you
can install the package from the local directory as editable using `pip install
-e .`.

##### 2. Run the server
  
Run the server using the following command:

```bash
signalstats1090 run --antenna-lat <antenna_lat> --antenna-lon <antenna_lon> --dump1090-host <dump1090_host>
```

The `--antenna-lat` and `--antenna-lon` arguments are required. You can find
the latitude and longitude of your antenna using Google Maps or similar
services.

If `dump1090` is running on a different host, you can specify the `--dump1090-host`
and `--dump1090-port` arguments. The default host is `localhost` and the default
port is `30005` (the default port for Beast output).

If you need to run the web server on a different host or port, you can specify
the `--host` and `--port` arguments. The default host is `0.0.0.0` which listens
on all interfaces. The default port is `8000`.

```bash
signalstats1090 run --host <host> --port <port> --antenna-lat <antenna_lat> --antenna-lon <antenna_lon> --dump1090-host <dump1090_host> --dump1090-port <dump1090_port>
```

##### 3. Access the dashboard

Open a web browser and navigate to the URL where the application is running. The
default URL is `http://localhost:8000` if you are running the application on the
local machine. If you are running the application on a different machine, replace
`localhost` with the IP address or hostname of the machine where the application
is running, e.g. `http://mypiaware:8000`.

### Charts

- **Message Rate Chart**: Displays message rates over different intervals (5s,
  15s, 30s, 60s, 300s).
- **Signal Strength Chart**: Displays minimum, average, and maximum signal
  strength over 30 seconds.
- **Distance Chart**: Displays minimum, maximum, and percentile distances over
  30 seconds.
- **Distance Histogram Chart**: Displays the count of position readings in 30km
  buckets (up to 300km).
- **Coverage Chart**: Displays coverage statistics in a radar chart, showing the
  distribution of messages by distance and bearing.
- **RSSI/Distance Ratio Chart**: Displays the ratio of RSSI to distance for each
  bearing segment.

## License

This project is licensed under the MIT License.