import 'package:utm/src/constants.dart';

const _minLat = -80;
const _maxLat = 84;
const _minLon = -180;
const _maxLon = 180;
const _minZone = 1;
const _maxZone = 60;

/// validate range of lat & lon
void validateRangeOfLatLon({
  required double lat,
  required double lon,
}) {
  if (lat < _minLat || _maxLat < lat) {
    throw RangeError.range(lat, _minLat, _maxLat);
  }
  if (lon < _minLon || _maxLon < lon) {
    throw RangeError.range(lon, _minLon, _maxLon);
  }
}

/// validate utm zone
void validateUtmZone({
  required double easting,
  required double northing,
  required int zoneNumber,
  required String zoneLetter,
}) {
  if (easting < 0) {
    throw RangeError.value(easting);
  }
  if (northing < 0) {
    throw RangeError.value(easting);
  }
  if (zoneNumber < _minZone || _maxZone < zoneNumber) {
    throw RangeError.range(zoneNumber, _minZone, _maxZone);
  }
  if (!zoneLetters.contains(zoneLetter)) {
    throw ArgumentError.value(zoneLetter);
  }
}
