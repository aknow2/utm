import 'package:utm/utm.dart';

main() {
  final utm = Utm.fromLatLon(-30, -150);
  print('zone: ${utm.zone}');
  print('N: ${utm.northing}');
  print('E: ${utm.easting}');
  print('lat: ${utm.lat}');
  print('lat: ${utm.lon}');

  final latlon = Utm.fromUtm(
    utm.easting,
    utm.northing,
    utm.zoneNumber,
    utm.zoneLetter,
  );

  print('lat: ${latlon.lat}');
  print('lon: ${latlon.lon}');
}
