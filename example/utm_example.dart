import 'package:utm/utm.dart';

main() {
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

  UTM.fromLatLon(lat: -30, lon: -150, type: GeodeticSystemType.bessel);
  UTM.fromUtm(
    easting: utm.easting,
    northing: utm.northing,
    zoneNumber: utm.zoneNumber,
    zoneLetter: utm.zoneLetter,
    type: GeodeticSystemType.grs80,
  );
}
