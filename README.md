# UTM dart  
Lat Lon and UTM bidirectional converter.  
translate from [Python UTM library](https://github.com/Turbo87/utm)

## Usage

```dart
import 'package:utm/utm.dart';

final utm = Utm.fromLatLon(-30, -150);
print('zone: ${utm.zone}');
print('N: ${utm.northing}');
print('E: ${utm.easting}');
print('lat: ${utm.lat}');
print('lat: ${utm.lon}');

final latlon = Utm.fromUtm(utm.easting, utm.northing, utm.zoneNumber, utm.zoneLetter);
print('lat: ${latlon.lat}');
print('lon: ${latlon.lon}');
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: 
