import 'package:angles/angles.dart';
import 'dart:math' as math;

const K0 = 0.9996;
const E = 0.00669438;
const E2 = E * E;
const E3 = E2 * E;
const E_P2 = E / (1.0 - E);

final SQRT_E = math.sqrt(1 - E);
final _E = (1 - SQRT_E) / (1 + SQRT_E);
final _E2 = _E * _E;
final _E3 = _E2 * _E;
final _E4 = _E3 * _E;
final _E5 = _E4 * _E;

final M1 = (1 - E / 4 - 3 * E2 / 64 - 5 * E3 / 256);
const M2 = (3 * E / 8 + 3 * E2 / 32 + 45 * E3 / 1024);
const M3 = (15 * E2 / 256 + 45 * E3 / 1024);
const M4 = (35 * E3 / 3072);

final P2 = (3/2 * _E - 27/32 * _E3 + 269/ 512 * _E5);
final P3 = (21/ 16 * _E2 - 55 / 32 * _E4);
final P4 = (151/ 96 * _E3 - 417/ 128 * _E5);
final P5 = (1097/ 512 * _E4);
const ZONE_LETTERS = "CDEFGHJKLMNPQRSTUVWXX";
const R = 6378137;

class Utm {
  final double lat;
  final double lon;
  final double easting;
  final double northing;
  final int zoneNumber;
  final String zoneLetter;
  String get zone => zoneNumber.toString() + zoneLetter;

  Utm(this.lat, this.lon, this.easting, this.northing, this.zoneNumber, this.zoneLetter);

  static Utm fromUtm(double easting, double northing, int zoneNumber, String zoneLetter) {
    return _utmToLatLon(easting, northing, zoneNumber, zoneLetter);
  }

  static Utm fromLatLon(double lat, double lon) {
    return _latlonToUtm(lat, lon);
  }
}

Utm _utmToLatLon(double easting, double northing, int zoneNumber, String zoneLetter) {
    final northern = zoneLetter != null && zoneLetter.toUpperCase().codeUnitAt(0) >= 'N'.codeUnitAt(0);
    final x = easting - 500000;
    final y =  northern ? northing : northing - 10000000;

    final m = y / K0;
    final mu = m / (R * M1);

    final pRad = (mu +
             P2 * math.sin(2 * mu) +
             P3 * math.sin(4 * mu) +
             P4 * math.sin(6 * mu) +
             P5 * math.sin(8 * mu));

    final pSin = math.sin(pRad);
    final pSin2 = pSin * pSin;

    final pCos = math.cos(pRad);

    final pTan = pSin / pCos;
    final pTan2 = pTan * pTan;
    final pTan4 = pTan2 * pTan2;

    final epSin = 1 - E * pSin2;
    final epSinSqrt = math.sqrt(1 - E * pSin2);

    final n = R / epSinSqrt;
    final r = (1 - E) / epSin;

    final c = _E *  math.pow(pCos, 2);
    final c2 = c * c;

    final d = x / (n * K0);
    final d2 = d * d;
    final d3 = d2 * d;
    final d4 = d3 * d;
    final d5 = d4 * d;
    final d6 = d5 * d;

    final lat = (pRad - (pTan / r) *
                (d2 / 2 -
                 d4 / 24 * (5 + 3 * pTan2 + 10 * c - 4 * c2 - 9 * E_P2)) +
                 d6 / 720 * (61 + 90 * pTan2 + 298 * c + 45 * pTan4 - 252 * E_P2 - 3 * c2));

    final lon = (d -
                 d3 / 6 * (1 + 2 * pTan2 + c) +
                 d5 / 120 * (5 - 2 * c + 28 * pTan2 - 3 * c2 + 8 * E_P2 + 24 * pTan4)) / pCos;

    return Utm(Angle.fromRadians(lat).degrees, Angle.fromRadians(lon).degrees + zoneNumber2CentralLon(zoneNumber), easting, northing, zoneNumber, zoneLetter);
}

int _latlon2zoneNumber (double lat, double lon) {
  if(56 <= lat && lat < 64 && 3 <= lon && lon < 12) {
    return 32;
  }
  if(72 <= lat && lat <= 84 && lon >= 0)  {
    if(lon < 9) {
      return 31;
    } else if (lon < 21)  {
      return 33;
    } else if (lon < 33) {
      return 35;
    } else if (lon < 42) {
      return 37;
    }
  }
  return (((lon + 180) / 6) + 1).floor();
}

Utm _latlonToUtm (double lat, double lon) {
  final latRad = Angle.fromDegrees(lat).radians;
  final latSin = math.sin(latRad);
  final latCos = math.cos(latRad);
  final latTan = latSin / latCos;
  final latTan2 = latTan * latTan;
  final latTan4 = latTan2 * latTan2;
  final zoneNumber = _latlon2zoneNumber(lat, lon);
  final lonRad = Angle.fromDegrees(lon).radians;
  final centralLon = zoneNumber2CentralLon(zoneNumber);
  final centralLonRad = Angle.fromDegrees(centralLon).radians;

  final n = R / math.sqrt(1 - E * math.pow(latSin, 2));
  final c = E_P2 * math.pow(latCos, 2);
  final a = latCos * (lonRad - centralLonRad);
  final a2 = a * a;
  final a3 = a2 * a;
  final a4 = a3 * a;
  final a5 = a4 * a;
  final a6 = a5 * a;
  final m = R * (M1 * latRad -
            M2 * math.sin(2 * latRad) +
            M3 * math.sin(4 * latRad) -
            M4 * math.sin(6 * latRad));
  final easting = K0 * n * (a +
                        a3 / 6 * (1 - latTan2 + c) +
                        a5 / 120 * (5 - 18 * latTan2 + latTan4 + 72 * c - 58 * E_P2)) + 500000;
  final offset = lat >= 0 ? 0 : 10000000; 
  final northing = K0 * (m + n * latTan * (a2 / 2 +
                                        a4 / 24 * (5 - latTan2 + 9 * c + 4 * math.pow(c, 2)) +
                                        a6 / 720 * (61 - 58 * latTan2 + latTan4 + 600 * c - 330 * E_P2))) + offset;
  return Utm(lat, lon, easting, northing, zoneNumber, _lat2zoneLetter(lat));
}

double zoneNumber2CentralLon(int zoneNumber) {
  return ((zoneNumber - 1) * 6.0 - 180.0 + 3.0);
}

String _lat2zoneLetter(double lat) {
  if (-80 <= lat && lat <= 84) {
    return ZONE_LETTERS[(lat + 80).toInt() >> 3];
  } else {
    return '';
  }
}

