/// type of geodetic system
enum GeodeticSystemType {
  /// WGS84 R=6378137 e=0.00669438
  wgs84,

  /// GRS80 R=6378137 e=0.00669438
  grs80,

  /// bessel R=6377397.155 e=0.00667437
  bessel
}

/// zone letters
final zoneLetters = "CDEFGHJKLMNPQRSTUVWXX";

///
class UtmCoordinate {
  /// Latitude
  final double lat;

  /// Longitude
  final double lon;

  /// the eastward-measured distance. (x-coordinate)
  final double easting;

  /// northward-measured distance. (y-coordinate)
  final double northing;

  /// zone number
  final int zoneNumber;

  /// zone letter
  final String zoneLetter;

  /// zone ex) 60S 50H
  String get zone => zoneNumber.toString() + zoneLetter;

  /// constructor
  const UtmCoordinate(this.lat, this.lon, this.easting, this.northing,
      this.zoneNumber, this.zoneLetter);
}


