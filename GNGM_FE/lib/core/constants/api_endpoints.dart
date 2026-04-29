// Import secrets (auto-synced from playground)
import 'app_secrets.dart';

class ApiEndpoints {
  // Base URLs (from secrets)
  static const String baseUrl = AppSecrets.baseUrl;
  static const String apiVersion = '/api/v1';
  static const String apiBaseUrl = baseUrl + apiVersion;

  // External Service API Keys (from secrets)
  static const String kakaoMapApiKey = AppSecrets.kakaoMapApiKey;
  static const String naverMapClientId = AppSecrets.naverMapClientId;
  static const String firebaseProjectId = AppSecrets.firebaseProjectId;

  // Auth Endpoints
  static const String auth = '/auth';
  static const String login = auth + '/login';
  static const String register = auth + '/register';
  static const String logout = auth + '/logout';
  static const String refresh = auth + '/refresh';
  static const String kakaoLogin = auth + '/kakao';
  static const String googleLogin = auth + '/google';

  // User Endpoints
  static const String users = '/users';
  static const String profile = users + '/profile';
  static const String updateProfile = users + '/profile';

  // Service Endpoints
  static const String services = '/services';
  static const String createService = services;
  static const String serviceDetail = services; // + '/{id}'
  static const String updateService = services; // + '/{id}'
  static const String deleteService = services; // + '/{id}'

  // Chat Endpoints
  static const String chat = '/chat';
  static const String chatRooms = chat + '/rooms';
  static const String chatMessages = chat + '/messages';

  // Location Endpoints
  static const String location = '/location';
  static const String nearbyServices = location + '/nearby';
  static const String geocoding = location + '/geocoding';

  // Helper methods
  static String serviceById(String id) => '$services/$id';
  static String updateServiceById(String id) => '$services/$id';
  static String deleteServiceById(String id) => '$services/$id';
  static String chatRoom(String roomId) => '$chatRooms/$roomId';
  static String chatMessagesInRoom(String roomId) => '$chatRooms/$roomId/messages';

  // Full URL builders
  static String fullUrl(String endpoint) => apiBaseUrl + endpoint;
}