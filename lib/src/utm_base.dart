// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// This is a lat lon and UTM bidirectional converter
import 'dart:math' as math;
import 'package:angles/angles.dart';

const _k0 = 0.9996;
final _r = 6378137;
final _e =  0.00669438; //;
final _e2 = _e * _e;
final _e3 = _e2 * _e;
final _eP2 = _e / (1.0 - _e);

final _sqrtE = math.sqrt(1 - _e);
final __e = (1 - _sqrtE) / (1 + _sqrtE);
final __e2 = __e * __e;
final __e3 = __e2 * __e;
final __e4 = __e3 * __e;
final __e5 = __e4 * __e;

final _m1 = (1 - _e / 4 - 3 * _e2 / 64 - 5 * _e3 / 256);
final _m2 = (3 * _e / 8 + 3 * _e2 / 32 + 45 * _e3 / 1024);
final _m3 = (15 * _e2 / 256 + 45 * _e3 / 1024);
final _m4 = (35 * _e3 / 3072);

final _p2 = (3 / 2 * __e - 27 / 32 * __e3 + 269 / 512 * __e5);
final _p3 = (21 / 16 * __e2 - 55 / 32 * __e4);
final _p4 = (151 / 96 * __e3 - 417 / 128 * __e5);
final _p5 = (1097 / 512 * __e4);
final _zoneLetter = "CDEFGHJKLMNPQRSTUVWXX";


/// type of geodetic system
enum GeodeticSystemType {
 /// WGS84
 wgs84,
 /// GRS80
 grs80,
 /// bessel
 bessel
}

class _GeoSysParam {
  final double r;
  final double e;

  _GeoSysParam(this.r, this.e);
}

final Map<GeodeticSystemType, _GeoSysParam> _geoSysMap  = {
  GeodeticSystemType.wgs84 : _GeoSysParam(6378137, 0.00669438),
  GeodeticSystemType.grs80 : _GeoSysParam(6378137	, 0.00669438),
  GeodeticSystemType.bessel : _GeoSysParam(6377397.155, 0.00667437),
};

/// UTM
class Utm {

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

  const Utm._(
    this.lat,
    this.lon,
    this.easting,
    this.northing,
    this.zoneNumber,
    this.zoneLetter
  );

  /// create UTM Object from UTM 
  static Utm fromUtm(
      double easting, double northing, int zoneNumber, String zoneLetter) {
    return _utmToLatLon(easting, northing, zoneNumber, zoneLetter);
  }

  /// create UTM Object from lat lon 
  static Utm fromLatLon(double lat, double lon) {
    return _latlonToUtm(lat, lon);
  }
}

Utm _utmToLatLon(
    double easting, double northing, int zoneNumber, String zoneLetter) {
  final northern = zoneLetter != null &&
      zoneLetter.toUpperCase().codeUnitAt(0) >= 'N'.codeUnitAt(0);
  final x = easting - 500000;
  final y = northern ? northing : northing - 10000000;

  final m = y / _k0;
  final mu = m / (_r * _m1);

  final pRad = (mu +
      _p2 * math.sin(2 * mu) +
      _p3 * math.sin(4 * mu) +
      _p4 * math.sin(6 * mu) +
      _p5 * math.sin(8 * mu));

  final pSin = math.sin(pRad);
  final pSin2 = pSin * pSin;

  final pCos = math.cos(pRad);

  final pTan = pSin / pCos;
  final pTan2 = pTan * pTan;
  final pTan4 = pTan2 * pTan2;

  final epSin = 1 - _e * pSin2;
  final epSinSqrt = math.sqrt(1 - _e * pSin2);

  final n = _r / epSinSqrt;
  final r = (1 - _e) / epSin;

  final c = __e * math.pow(pCos, 2);
  final c2 = c * c;

  final d = x / (n * _k0);
  final d2 = d * d;
  final d3 = d2 * d;
  final d4 = d3 * d;
  final d5 = d4 * d;
  final d6 = d5 * d;

  final lat = (pRad -
      (pTan / r) *
          (d2 / 2 - d4 / 24 * (5 + 3 * pTan2 + 10 * c - 4 * c2 - 9 * _eP2)) +
      d6 /
          720 *
          (61 + 90 * pTan2 + 298 * c + 45 * pTan4 - 252 * _eP2 - 3 * c2));

  final lon = (d -
          d3 / 6 * (1 + 2 * pTan2 + c) +
          d5 /
              120 *
              (5 - 2 * c + 28 * pTan2 - 3 * c2 + 8 * _eP2 + 24 * pTan4)) /
      pCos;

  return Utm._(
      Angle.fromRadians(lat).degrees,
      Angle.fromRadians(lon).degrees + _zoneNumber2CentralLon(zoneNumber),
      easting,
      northing,
      zoneNumber,
      zoneLetter);
}

int _latlon2zoneNumber(double lat, double lon) {
  if (56 <= lat && lat < 64 && 3 <= lon && lon < 12) {
    return 32;
  }
  if (72 <= lat && lat <= 84 && lon >= 0) {
    if (lon < 9) {
      return 31;
    } else if (lon < 21) {
      return 33;
    } else if (lon < 33) {
      return 35;
    } else if (lon < 42) {
      return 37;
    }
  }
  return (((lon + 180) / 6) + 1).floor();
}

Utm _latlonToUtm(double lat, double lon) {
  final latRad = Angle.fromDegrees(lat).radians;
  final latSin = math.sin(latRad);
  final latCos = math.cos(latRad);
  final latTan = latSin / latCos;
  final latTan2 = latTan * latTan;
  final latTan4 = latTan2 * latTan2;
  final zoneNumber = _latlon2zoneNumber(lat, lon);
  final lonRad = Angle.fromDegrees(lon).radians;
  final centralLon = _zoneNumber2CentralLon(zoneNumber);
  final centralLonRad = Angle.fromDegrees(centralLon).radians;

  final n = _r / math.sqrt(1 - _e * math.pow(latSin, 2));
  final c = _eP2 * math.pow(latCos, 2);
  final a = latCos * (lonRad - centralLonRad);
  final a2 = a * a;
  final a3 = a2 * a;
  final a4 = a3 * a;
  final a5 = a4 * a;
  final a6 = a5 * a;
  final m = _r *
      (_m1 * latRad -
          _m2 * math.sin(2 * latRad) +
          _m3 * math.sin(4 * latRad) -
          _m4 * math.sin(6 * latRad));
  final easting = _k0 *
          n *
          (a +
              a3 / 6 * (1 - latTan2 + c) +
              a5 / 120 * (5 - 18 * latTan2 + latTan4 + 72 * c - 58 * _eP2)) +
      500000;
  final offset = lat >= 0 ? 0 : 10000000;
  final northing = _k0 *
          (m +
              n *
                  latTan *
                  (a2 / 2 +
                      a4 / 24 * (5 - latTan2 + 9 * c + 4 * math.pow(c, 2)) +
                      a6 /
                          720 *
                          (61 -
                              58 * latTan2 +
                              latTan4 +
                              600 * c -
                              330 * _eP2))) +
      offset;
  return Utm._(lat, lon, easting, northing, zoneNumber, _lat2zoneLetter(lat));
}

double _zoneNumber2CentralLon(int zoneNumber) {
  return ((zoneNumber - 1) * 6.0 - 180.0 + 3.0);
}

String _lat2zoneLetter(double lat) {
  if (-80 <= lat && lat <= 84) {
    return _zoneLetter[(lat + 80).toInt() >> 3];
  } else {
    return '';
  }
}
