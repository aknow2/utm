import 'dart:math' as math;
import 'package:angles/angles.dart';
import 'package:utm/src/constants.dart';

class _GeoSysParam {
  final double r;
  final double e;

  _GeoSysParam(this.r, this.e);
}

final Map<GeodeticSystemType, _GeoSysParam> _geoSysMap = {
  GeodeticSystemType.wgs84: _GeoSysParam(6378137, 0.00669438),
  GeodeticSystemType.grs80: _GeoSysParam(6378137, 0.00669438),
  GeodeticSystemType.bessel: _GeoSysParam(6377397.155, 0.00667437),
};

/// UTM bidirectional converter
class UtmConverter {
  final _k0 = 0.9996;
  late double _r;
  late double _e;
  late double _e2;
  late double _e3;
  late double _eP2;

  late double _sqrtE;
  late double __e;
  late double __e2;
  late double __e3;
  late double __e4;
  late double __e5;

  late double _m1;
  late double _m2;
  late double _m3;
  late double _m4;

  late double _p2;
  late double _p3;
  late double _p4;
  late double _p5;

  /// constructor
  UtmConverter(GeodeticSystemType type) {
    final param = _geoSysMap[type];
    _r = param!.r;
    _e = param.e;
    _e2 = _e * _e;
    _e3 = _e2 * _e;
    _eP2 = _e / (1.0 - _e);

    _sqrtE = math.sqrt(1 - _e);
    __e = (1 - _sqrtE) / (1 + _sqrtE);
    __e2 = __e * __e;
    __e3 = __e2 * __e;
    __e4 = __e3 * __e;
    __e5 = __e4 * __e;

    _m1 = (1 - _e / 4 - 3 * _e2 / 64 - 5 * _e3 / 256);
    _m2 = (3 * _e / 8 + 3 * _e2 / 32 + 45 * _e3 / 1024);
    _m3 = (15 * _e2 / 256 + 45 * _e3 / 1024);
    _m4 = (35 * _e3 / 3072);

    _p2 = (3 / 2 * __e - 27 / 32 * __e3 + 269 / 512 * __e5);
    _p3 = (21 / 16 * __e2 - 55 / 32 * __e4);
    _p4 = (151 / 96 * __e3 - 417 / 128 * __e5);
    _p5 = (1097 / 512 * __e4);
  }

  /// convert to lat&lon from UTM
  UtmCoordinate utmToLatLon(
      double easting, double northing, int zoneNumber, String? zoneLetter) {
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

    return UtmCoordinate(
      Angle.radians(lat).degrees,
      Angle.radians(lon).degrees + _zoneNumber2CentralLon(zoneNumber),
      easting,
      northing,
      zoneNumber,
      zoneLetter!,
    );
  }

  /// convert to UTM from lat&lon
  UtmCoordinate latlonToUtm(double lat, double lon) {
    final latRad = Angle.degrees(lat).radians;
    final latSin = math.sin(latRad);
    final latCos = math.cos(latRad);
    final latTan = latSin / latCos;
    final latTan2 = latTan * latTan;
    final latTan4 = latTan2 * latTan2;
    final zoneNumber = _latlon2zoneNumber(lat, lon);
    final lonRad = Angle.degrees(lon).radians;
    final centralLon = _zoneNumber2CentralLon(zoneNumber);
    final centralLonRad = Angle.degrees(centralLon).radians;

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
    return UtmCoordinate(
        lat, lon, easting, northing, zoneNumber, _lat2zoneLetter(lat));
  }

  String _lat2zoneLetter(double lat) {
    if (-80 <= lat && lat <= 84) {
      return zoneLetters[(lat + 80).toInt() >> 3];
    } else {
      return '';
    }
  }
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

double _zoneNumber2CentralLon(int zoneNumber) {
  return ((zoneNumber - 1) * 6.0 - 180.0 + 3.0);
}
