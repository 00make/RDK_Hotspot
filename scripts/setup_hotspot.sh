#!/bin/bash

# 更新软件包列表
sudo apt update

# 安装必要的软件
sudo apt install -y network-manager dnsmasq haveged

# 克隆 create_ap 仓库并安装
git clone https://github.com/oblique/create_ap.git
cd create_ap
sudo make install

# 配置 iptables
sudo update-alternatives --config iptables <<EOF
选择iptables-legacy
EOF

# 创建 WiFi 热点
sudo create_ap wlan0 wlan0 X5

# 创建 Systemd 服务单元文件
SERVICE_FILE="/etc/systemd/system/create_ap.service"

echo "[Unit]
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
WantedBy=multi-user.target" | sudo tee $SERVICE_FILE

# 启用 Systemd 服务
sudo systemctl daemon-reload
sudo systemctl enable create_ap.service

# 提示用户启动服务
echo "WiFi 热点已设置完成。您可以使用以下命令启动服务："
echo "sudo systemctl start create_ap.service"