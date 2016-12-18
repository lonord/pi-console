# Pi-Console

摆脱网线或者Wi-Fi，直接使用手机蓝牙连接树莓派终端，配上电源就可以将树莓派变为随身工作站。

程序包含运行在树莓派上的服务端和运行在控制设备的客户端，客户端暂支持iOS。

理论上支持所有型号树莓派。

## 硬件

- 树莓派
- 蓝牙4.0透传模块（我用的是常见的DX-BT05那种，蓝牙芯片是CC2541）
- 树莓派UPS电源模块（这个可选，淘宝上只有一家有卖，功能上也还有点问题，暂时不是很推荐）

## 安装&使用方法

##### 1. 配置Pi内置串口

树莓派内置串口（GPIO 14，GPIO 15）默认是用作调试端口的，这里需要改一下，把串口映射到 **/dev/ttyAMA0** 用作自定义用途。

树莓派3因为有蓝牙，方法有点不一样，附上树莓派3改串口的方法 [https://openenergymonitor.org/emon/node/12311](https://openenergymonitor.org/emon/node/12311 "https://openenergymonitor.org/emon/node/12311")

##### 2. 安装Node.js

前往[nodejs.org](https://nodejs.org "nodejs.org")安装Node.js，可以直接下载二进制文件，也可以下载源码编译安装，编译安装没啥特别要注意的，这里就不多介绍啦。

##### 3. 将pi_console_server拷贝到树莓派

```bash
cd path/to/pi_console_server
npm install
```

##### 4. 配置透传模块

把蓝牙透传模块连接到树莓派，注意树莓派上串口RX要接模块串口TX，树莓派TX连模块串口RX。

运行自动配置脚本：

```bash
node setup-bluetooth-module.js
```

##### 5. 运行

```bash
npm start
```

##### 6. 运行iOS客户端

使用xcode打开工程文件，运行即可。（注意：由于使用了蓝牙4.0功能，务必使用真机调试）

程序启动后搜索蓝牙设备，选择名称为 **PI-CONSOLE-xxxx** 的设备，连接成功后即可开始操作。

## License

MIT License. See the LICENSE file.