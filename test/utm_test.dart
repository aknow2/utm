import 'package:utm/utm.dart';
import 'package:test/test.dart';

void main() {
  test('latlon to utm Test in tokyo', () {
    final utm = Utm.fromLatLon(35.720122, 139.752899);
    expect(utm.northing, closeTo(3953623.37, 0.1));
    expect(utm.easting, closeTo(387203.09, 0.1));
    expect(utm.zoneLetter, equals('S'));
    expect(utm.zoneNumber, equals(54));
  });
  test('utm to lat lon Test in tokyo', () {
    final utm = Utm.fromUtm(387203.09, 3953623.37, 54, 'S');
    expect(utm.northing, closeTo(3953623.37, 0.1));
    expect(utm.easting, closeTo(387203.09, 0.1));
    expect(utm.zone, equals('54S'));
    expect(utm.lat, closeTo(35.720122, 0.1));
    expect(utm.lon, closeTo(139.752899, 0.1));
  });
  test('latlon to utm Test in Sydney', () {
    final utm = Utm.fromLatLon(-34.452211, 150.947302);
    expect(utm.northing, closeTo(6185790.53, 0.1));
    expect(utm.easting, closeTo(311433.56, 0.1));
    expect(utm.zoneLetter, equals('H'));
    expect(utm.zoneNumber, equals(56));
  });
}
