import 'package:utm/utm.dart';
import 'package:test/test.dart';

void main() {
  test('latlon to utm Test in tokyo', () {
    final utm = UTM.fromLatLon(lat: 35.720122, lon: 139.752899);
    expect(utm.northing, closeTo(3953623.37, 0.1));
    expect(utm.easting, closeTo(387203.09, 0.1));
    expect(utm.zoneLetter, equals('S'));
    expect(utm.zoneNumber, equals(54));
  });
  test('utm to lat lon Test in tokyo', () {
    final utm = UTM.fromUtm(
      easting: 387203.09, northing: 3953623.37, zoneNumber:54, zoneLetter: 'S');
    expect(utm.northing, closeTo(3953623.37, 0.1));
    expect(utm.easting, closeTo(387203.09, 0.1));
    expect(utm.zone, equals('54S'));
    expect(utm.lat, closeTo(35.720122, 0.1));
    expect(utm.lon, closeTo(139.752899, 0.1));
  });
  test('latlon to utm Test in Sydney', () {
    final utm = UTM.fromLatLon(lat: -34.452211, lon: 150.947302);
    expect(utm.northing, closeTo(6185790.53, 0.1));
    expect(utm.easting, closeTo(311433.56, 0.1));
    expect(utm.zoneLetter, equals('H'));
    expect(utm.zoneNumber, equals(56));
  });
  test('latlon to utm Test in zone 32', () {
    final utm = UTM.fromLatLon(lat: 63.506144, lon: 9.20091);
    expect(utm.northing, closeTo(7042000, 0.1));
    expect(utm.easting, closeTo(510000, 0.1));
    expect(utm.zoneLetter, equals('V'));
    expect(utm.zoneNumber, equals(32));
  });
  test('latlon to utm Test in zone 33', () {
    final utm = UTM.fromLatLon(lat: 72.506144, lon: 20.20091);
    expect(utm.zoneLetter, equals('X'));
    expect(utm.zoneNumber, equals(33));
  });
  test('latlon to utm Test in zone 35', () {
    final utm = UTM.fromLatLon(lat: 72.506144, lon: 30.20091);
    expect(utm.zoneLetter, equals('X'));
    expect(utm.zoneNumber, equals(35));
  });
  test('latlon to utm Test in zone 37', () {
    final utm = UTM.fromLatLon(lat: 72.506144, lon: 40.20091);
    expect(utm.zoneLetter, equals('X'));
    expect(utm.zoneNumber, equals(37));
  });
}
