# RDK WiFi Hotspot Setup Guide

Welcome to the RDK WiFi Hotspot project! This guide will walk you through the steps to create a WiFi hotspot on your RDK board. Please follow the instructions carefully to ensure successful setup.

## Prerequisites

Before starting, make sure you have:

- An RDK board with a compatible operating system (like Ubuntu) installed.
- A stable internet connection for downloading necessary packages.

## Step 1: Install Required Software

Open a terminal and run the following commands to install necessary packages:

```shell
sudo apt install network-manager 
sudo apt install dnsmasq 
sudo apt install haveged
```

## Step 2: Clone the create_ap Repository

Next, you need to clone the `create_ap` repository, which will help you create the hotspot:

```shell
git clone https://github.com/oblique/create_ap.git
cd create_ap
sudo make install
```

## Step 3: Configure iptables

You need to configure iptables to use the legacy version. Run the following command:

```shell
sudo update-alternatives --config iptables
```

When prompted, select `iptables-legacy`.

## Step 4: Create WiFi Hotspot

Now you can create a WiFi hotspot using the following command:

```shell
create_ap wlan0 wlan0 X5
```

If your network interface name is different, replace `wlan0` with the actual name.

## Step 5: Setup Automatic Startup

To ensure the hotspot starts automatically at boot, you need to create a Systemd service unit file. Follow these steps:

1. Create a service file:

```bash
sudo nano /etc/systemd/system/create_ap.service
```

2. Paste the following content into the file, adjusting paths and interface names as needed:

```ini
[Unit]
Description=Create AP Hotspot Service
After=network.target 
Wants=network-online.target  

[Service]
Type=simple
WorkingDirectory=/root/webxr/create_ap 
ExecStart=/usr/bin/create_ap wlan0 wlan0 X5
Restart=on-failure  
RestartSec=5 
User=root  

[Install]
WantedBy=multi-user.target 
```

3. Save and exit the editor (in nano, press `Ctrl+X`, then `Y`, and finally `Enter`).

## Step 6: Enable and Start the Service

Run the following commands to enable the service to start at boot and start it immediately:

```bash
sudo systemctl daemon-reload
sudo systemctl enable create_ap.service
sudo systemctl start create_ap.service
```

## Step 7: Verify the Service

To check the status of the service, use:

```bash
sudo systemctl status create_ap.service
```

If there are any issues, you can view the logs with:

```bash
journalctl -u create_ap.service
```

## Step 8: Reboot and Test

Finally, reboot your RDK board to test if the hotspot starts automatically:

```bash
sudo reboot
```

## Additional Notes

- If you need to stop or disable the service, you can use the following commands:

```bash
sudo systemctl stop create_ap.service
sudo systemctl disable create_ap.service
```

## Conclusion

You have successfully set up a WiFi hotspot on your RDK board! If you encounter any issues, please refer to the logs or seek help from the community. Happy networking!
