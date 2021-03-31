// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:utm/src/constants.dart';

/// This is a lat lon and UTM bidirectional converter
import 'package:utm/src/converter.dart';
import 'package:utm/src/validator.dart';

/// UTM
class UTM {
  /// create [UtmCoordinate] from UTM coordinates.
  /// [easting] easting value. x-coordinate
  /// [northing] northing value. y-coordinate
  /// [zoneNumber] number of UTM zone. 1 to 60
  /// [zoneLetter] String value of UTM zone. CDEFGHJKLMNPQRSTUVWXX
  /// [type] type of Geodetic System. Default is WGS84. see [GeodeticSystemType]
  static UtmCoordinate fromUtm({
    required double easting,
    required double northing,
    required int zoneNumber,
    required String zoneLetter,
    GeodeticSystemType type = GeodeticSystemType.wgs84,
  }) {
    validateUtmZone(
        easting: easting,
        northing: northing,
        zoneLetter: zoneLetter,
        zoneNumber: zoneNumber);
    return UtmConverter(type)
        .utmToLatLon(easting, northing, zoneNumber, zoneLetter);
  }

  /// create [UtmCoordinate] from latitude & longitude
  /// [lat] latitude between -80 and 84 deg
  /// [lon] longitude between -180 and 180 deg
  /// [type] type of Geodetic System. Default is WGS84. see [GeodeticSystemType]
  static UtmCoordinate fromLatLon({
    required double lat,
    required double lon,
    GeodeticSystemType type = GeodeticSystemType.wgs84,
  }) {
    validateRangeOfLatLon(lat: lat, lon: lon);
    return UtmConverter(type).latlonToUtm(lat, lon);
  }
}
