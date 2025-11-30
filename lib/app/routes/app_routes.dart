part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const HOME = _Paths.HOME;
  static const GPS_LOCATION = '/gps-location';
  static const NETWORK_LOCATION = '/network-location';
  static const LOCATION = '/location';
}

abstract class _Paths {
  _Paths._();
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const HOME = '/mochi';
  static const GPS_LOCATION = '/gps-location';
  static const NETWORK_LOCATION = '/network-location';
  static const LOCATION = '/location';
}
