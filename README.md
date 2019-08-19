# UTM dart  
Lat Lon and UTM bidirectional converter.  
translate from [Python UTM library](https://github.com/Turbo87/utm)  
  
Support Geodetic System  
- WGS84 (default)
- GRS80
- Bessel

The UTM coordinate system is explained on this [Wikipedia](https://en.wikipedia.org/wiki/Universal_Transverse_Mercator_coordinate_system) page.

## Usage

Simple usage.  
Default geodetic system is WGS84
```dart
import 'package:utm/utm.dart';

final utm = UTM.fromLatLon(lat: -30, lon: -150);
print('zone: ${utm.zone}');
print('N: ${utm.northing}');
print('E: ${utm.easting}');
print('lat: ${utm.lat}');
print('lat: ${utm.lon}');

final latlon = UTM.fromUtm(
  easting: utm.easting,
  northing: utm.northing,
  zoneNumber: utm.zoneNumber,
  zoneLetter: utm.zoneLetter,
);
print('lat: ${latlon.lat}');
print('lon: ${latlon.lon}');

```
  
Use specific geodetic system  
```dart
UTM.fromLatLon(lat: -30, lon: -150, type: GeodeticSystemType.bessel);
UTM.fromUtm(
  easting: utm.easting,
  northing: utm.northing,
  zoneNumber: utm.zoneNumber,
  zoneLetter: utm.zoneLetter,
  type: GeodeticSystemType.grs80,
);
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: 
