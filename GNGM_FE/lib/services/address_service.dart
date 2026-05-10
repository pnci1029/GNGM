import 'package:dio/dio.dart';

class AddressService {
  final Dio _dio = Dio();
  static const String _baseUrl = 'https://dapi.kakao.com/v2/local/geo/coord2address.json';
  
  static const String _kakaoApiKey = String.fromEnvironment('KAKAO_API_KEY', defaultValue: '');

  Future<String> getAddressFromCoordinates(double lat, double lng) async {
    if (_kakaoApiKey.isEmpty) {
      return '위치 정보 없음 (API 키 누락)';
    }
    
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'x': lng.toString(),
          'y': lat.toString(),
          'input_coord': 'WGS84',
        },
        options: Options(
          headers: {
            'Authorization': 'KakaoAK $_kakaoApiKey',
            'Content-Type': 'application/json',
          },
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      print('📡 API 응답 상태: ${response.statusCode}');
      print('📡 API 응답 데이터: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;
        final documents = data['documents'] as List?;
        
        print('📄 Documents 개수: ${documents?.length ?? 0}');
        
        if (documents != null && documents.isNotEmpty) {
          final address = documents[0]['address'];
          print('🏠 주소 정보: $address');
          
          if (address != null) {
            final region1 = address['region_1depth_name'] ?? '';
            final region2 = address['region_2depth_name'] ?? '';
            final region3 = address['region_3depth_name'] ?? '';
            
            print('🗾 지역 정보: region1=$region1, region2=$region2, region3=$region3');
            
            // "서울시 강남구" 형태로 반환
            String addressText = '';
            if (region1.isNotEmpty) {
              addressText = region1;
              if (region2.isNotEmpty) {
                addressText += ' $region2';
                if (region3.isNotEmpty) {
                  // 동 정보도 포함하고 싶다면 주석 해제
                  // addressText += ' $region3';
                }
              }
            }
            
            print('✅ 최종 주소: $addressText');
            return addressText.isNotEmpty ? addressText : '위치 정보 없음';
          }
        } else {
          print('❌ 문서가 비어있음');
        }
      } else {
        print('❌ API 응답 실패: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('🔥 주소 변환 실패: $e');
      print('🔥 스택 트레이스: $stackTrace');
      // 간단한 에러 처리 (API 키 문제일 가능성도 있음)
      return '주소 변환 실패';
    }
    
    print('⚠️ 주소 정보를 찾을 수 없음');
    return '위치 정보 없음';
  }

  // 더 상세한 주소 정보가 필요한 경우 사용
  Future<Map<String, String>> getDetailedAddress(double lat, double lng) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'x': lng.toString(),
          'y': lat.toString(),
          'input_coord': 'WGS84',
        },
        options: Options(
          headers: {
            'Authorization': 'KakaoAK $_kakaoApiKey',
            'Content-Type': 'application/json',
          },
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final documents = data['documents'] as List?;
        
        if (documents != null && documents.isNotEmpty) {
          final address = documents[0]['address'];
          
          if (address != null) {
            return {
              'region1': address['region_1depth_name'] ?? '',
              'region2': address['region_2depth_name'] ?? '',
              'region3': address['region_3depth_name'] ?? '',
              'roadAddress': documents[0]['road_address']?['address_name'] ?? '',
              'fullAddress': address['address_name'] ?? '',
            };
          }
        }
      }
    } catch (e) {
      print('🔥 상세 주소 변환 실패: $e');
    }
    
    return {
      'region1': '',
      'region2': '',
      'region3': '',
      'roadAddress': '',
      'fullAddress': '위치 정보 없음',
    };
  }
}