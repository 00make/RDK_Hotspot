# RDK WiFi 热点设置指南

欢迎使用 RDK WiFi 热点项目！本指南将引导您完成在 RDK 板上创建 WiFi 热点的步骤。请仔细按照说明操作，以确保成功设置。

## 前提条件

在开始之前，请确保您具备以下条件：

- 安装了兼容操作系统（如 Ubuntu）的 RDK 板。
- 稳定的互联网连接，用于下载必要的软件包。

## 步骤 1：安装所需软件

打开终端并运行以下命令来安装必要的软件包：

```shell
sudo apt install network-manager 
sudo apt install dnsmasq 
sudo apt install haveged
```

## 步骤 2：克隆 create_ap 仓库

接下来，您需要克隆 `create_ap` 仓库，这将帮助您创建热点：

```shell
git clone https://github.com/oblique/create_ap.git
cd create_ap
sudo make install
```

## 步骤 3：配置 iptables

您需要将 iptables 配置为使用传统版本。运行以下命令：

```shell
sudo update-alternatives --config iptables
```

当提示时，选择 `iptables-legacy`。

## 步骤 4：创建 WiFi 热点

现在您可以使用以下命令创建 WiFi 热点：

```shell
create_ap wlan0 wlan0 X5
```

如果您的网络接口名称不同，请替换 `wlan0` 为实际的名称。

## 步骤 5：设置自动启动

为确保热点在启动时自动开启，您需要创建一个 Systemd 服务单元文件。按照以下步骤操作：

1. 创建服务文件：

```bash
sudo nano /etc/systemd/system/create_ap.service
```

2. 将以下内容粘贴到文件中，根据需要调整路径和接口名称：

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

3. 保存并退出编辑器（在 nano 中，按 `Ctrl+X`，然后 `Y`，最后 `Enter`）。

## 步骤 6：启用并启动服务

运行以下命令以启用服务在启动时自动启动，并立即启动它：

```bash
sudo systemctl daemon-reload
sudo systemctl enable create_ap.service
sudo systemctl start create_ap.service
```

## 步骤 7：验证服务

要检查服务的状态，请使用：

```bash
sudo systemctl status create_ap.service
```

如果有任何问题，您可以通过以下方式查看日志：

```bash
journalctl -u create_ap.service
```

## 步骤 8：重启并测试

最后，重启您的 RDK 板以测试热点是否自动启动：

```bash
sudo reboot
```

## 附加说明

- 如果您需要停止或禁用该服务，可以使用以下命令：

```bash
sudo systemctl stop create_ap.service
sudo systemctl disable create_ap.service
```

## 总结

您已成功在 RDK 板上设置了 WiFi 热点！如果遇到任何问题，请参考日志或向社区寻求帮助。祝您网络愉快！
