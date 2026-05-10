import 'dart:async';
import 'dart:js_util' as js_util;
import 'dart:html' as html;

class WebLocationService {
  Future<Map<String, double>?> getCurrentPosition() async {
    try {
      if (!isLocationSupported()) {
        return null;
      }
      
      final completer = Completer<Map<String, double>?>();
      
      // JS interop를 사용한 HTML5 geolocation API 호출
      final navigator = html.window.navigator;
      final geolocation = js_util.getProperty(navigator, 'geolocation');
      
      if (geolocation == null) {
        return null;
      }
      
      // 성공 콜백 함수
      void successCallback(dynamic position) {
        try {
          final coords = js_util.getProperty(position, 'coords');
          final lat = js_util.getProperty(coords, 'latitude') as num?;
          final lng = js_util.getProperty(coords, 'longitude') as num?;
          
          if (lat != null && lng != null) {
            completer.complete({
              'latitude': lat.toDouble(),
              'longitude': lng.toDouble(),
            });
          } else {
            completer.complete(null);
          }
        } catch (e) {
          completer.complete(null);
        }
      }
      
      // 에러 콜백 함수
      void errorCallback(dynamic error) {
        try {
          completer.complete(null);
        } catch (e) {
          completer.complete(null);
        }
      }
      
      // 옵션 설정
      final options = js_util.jsify({
        'enableHighAccuracy': true,
        'timeout': 15000,
        'maximumAge': 600000,
      });
      
      // geolocation.getCurrentPosition 호출
      js_util.callMethod(geolocation, 'getCurrentPosition', [
        js_util.allowInterop(successCallback),
        js_util.allowInterop(errorCallback),
        options,
      ]);
      
      return await completer.future.timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          return null;
        },
      );
    } catch (e, stackTrace) {
      return null;
    }
  }
  
  bool isLocationSupported() {
    final navigator = html.window.navigator;
    final geolocation = js_util.getProperty(navigator, 'geolocation');
    return geolocation != null;
  }
}