// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:meta/meta.dart';
import 'package:utm/src/constants.dart';

/// This is a lat lon and UTM bidirectional converter
import 'package:utm/src/converter.dart';

/// UTM
class UTM {
  /// create UTM Object from UTM
  static UtmResult fromUtm(
      {@required double easting,
      @required double northing,
      @required int zoneNumber,
      @required String zoneLetter,
      GeodeticSystemType type = GeodeticSystemType.wgs84}) {
    return UtmConverter(type)
        .utmToLatLon(easting, northing, zoneNumber, zoneLetter);
  }

  /// create UTM Object from lat lon
  static UtmResult fromLatLon(
      {@required double lat,
      @required double lon,
      GeodeticSystemType type = GeodeticSystemType.wgs84}) {
    return UtmConverter(type).latlonToUtm(lat, lon);
  }
}
