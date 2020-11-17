# Vagrant Kuksa

[Kuksa](https://www.eclipse.org/kuksa/)

- [Kuksa IDE](https://github.com/eclipse/kuksa.ide)
- [Kuksa In-Vehicle](https://github.com/eclipse/kuksa.invehicle)
- [Kuksa Cloud](https://github.com/eclipse/kuksa.cloud)
- [KUKSA Vehicle Abstration Layer](https://github.com/eclipse/kuksa.val) provides
a [Genivi VSS data
model](https://github.com/GENIVI/vehicle_signal_specification) describing data
in a vehicle. This data is provided to applications using various interfaces,
i.e. a websocket interface based on the [W3C Vehicle Information Service
Specification](https://www.w3.org/TR/2018/CR-vehicle-information-service-20180213/).

## CAN bus

[CAN bus tutorial](http://socialledge.com/sjsu/index.php/CAN_BUS_Tutorial)
[CAN dev studio](https://github.com/jgamblin/CarHackingTools)

### DBC

[DBC](http://socialledge.com/sjsu/index.php/DBC_Format) is a
proprietary format that describes the data over a CAN bus.

[openDBC](https://github.com/commaai/opendbc)

### VCAN

[Source](https://developers.redhat.com/blog/2018/10/22/introduction-to-linux-interfaces-for-virtual-networking/#vcan)

Similar to the network loopback devices, the VCAN (virtual CAN) driver offers a
virtual local CAN (Controller Area Network) interface, so users can send/receive
CAN messages via a VCAN interface. CAN is mostly used in the automotive field
nowadays.

For more CAN protocol information, please refer to the [kernel CAN
documentation](https://www.kernel.org/doc/Documentation/networking/can.txt).

Use a VCAN when you want to test a CAN protocol implementation on the local
host.

Here’s how to create a VCAN:

```bash
ip link add dev vcan1 type vcan
```
