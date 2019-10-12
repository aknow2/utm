import 'package:utm/src/converter.dart';
import 'package:utm/utm.dart';
import 'package:test/test.dart';

void main() {
  test('lat range test', () {
    expect(() => UTM.fromLatLon(lat: -81, lon: 0), throwsRangeError);
    expect(UTM.fromLatLon(lat: -80, lon: 0), TypeMatcher<UtmCoordinate>());
    expect(UTM.fromLatLon(lat: 84, lon: 0), TypeMatcher<UtmCoordinate>());
    expect(() => UTM.fromLatLon(lat: 85, lon: 0), throwsRangeError);
  });
  test('lat range test', () {
    expect(() => UTM.fromLatLon(lat: 0, lon: -181), throwsRangeError);
    expect(UTM.fromLatLon(lat: 0, lon: -180), TypeMatcher<UtmCoordinate>());
    expect(UTM.fromLatLon(lat: 0, lon: 180), TypeMatcher<UtmCoordinate>());
    expect(() => UTM.fromLatLon(lat: 0, lon: 181), throwsRangeError);
  });
  test('zone number range test', () {
    expect(
        () => UTM.fromUtm(
            easting: 1, northing: 1, zoneNumber: 0, zoneLetter: 'S'),
        throwsRangeError);
    expect(UTM.fromUtm(easting: 1, northing: 1, zoneNumber: 1, zoneLetter: 'S'),
        TypeMatcher<UtmCoordinate>());
    expect(
        UTM.fromUtm(easting: 1, northing: 1, zoneNumber: 60, zoneLetter: 'S'),
        TypeMatcher<UtmCoordinate>());
    expect(
        () => UTM.fromUtm(
            easting: 1, northing: 1, zoneNumber: 61, zoneLetter: 'S'),
        throwsRangeError);
  });
  test('invalid zone letter', () {
    expect(
        () => UTM.fromUtm(
            easting: -1, northing: 1, zoneNumber: 1, zoneLetter: 'S'),
        throwsRangeError);
  });
  test('invalid zone letter', () {
    expect(
        () => UTM.fromUtm(
            easting: 1, northing: 1, zoneNumber: 1, zoneLetter: 'A'),
        throwsArgumentError);
    expect(
        () => UTM.fromUtm(
            easting: 1, northing: 1, zoneNumber: 1, zoneLetter: 'Z'),
        throwsArgumentError);
  });
}
