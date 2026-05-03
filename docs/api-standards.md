# GNGM API 응답 표준 및 에러 처리

## API 응답 표준

### 통일된 응답 구조

모든 API 응답은 다음 구조를 따라야 합니다:

```typescript
interface ApiResponse<T = any> {
  success: boolean;           // 성공/실패 여부
  code: string;              // 응답 코드 (커스텀)
  message: string;           // 사용자에게 표시할 메시지
  data?: T;                  // 실제 데이터 (성공 시)
  error?: {                  // 에러 정보 (실패 시)
    type: string;            // 에러 타입
    details?: any;           // 상세 에러 정보
    timestamp: string;       // 에러 발생 시간
  };
  meta?: {                   // 메타 정보 (페이징 등)
    page?: number;
    limit?: number;
    total?: number;
    hasNext?: boolean;
  };
}
```

### 성공 응답 예시

#### 200 OK - 일반적인 성공
```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "요청이 성공적으로 처리되었습니다.",
  "data": {
    "id": 123,
    "name": "홍길동",
    "email": "hong@example.com"
  }
}
```

#### 201 Created - 생성 성공
```json
{
  "success": true,
  "code": "CREATED",
  "message": "서비스 요청이 등록되었습니다.",
  "data": {
    "id": 456,
    "title": "홈플러스 가는김에 생필품 사다드려요",
    "status": "PENDING"
  }
}
```

#### 200 OK - 페이징 데이터
```json
{
  "success": true,
  "code": "SUCCESS",
  "message": "목록을 조회했습니다.",
  "data": [
    {"id": 1, "title": "서비스1"},
    {"id": 2, "title": "서비스2"}
  ],
  "meta": {
    "page": 1,
    "limit": 10,
    "total": 25,
    "hasNext": true
  }
}
```

### 에러 응답 예시

#### 400 Bad Request - 잘못된 요청
```json
{
  "success": false,
  "code": "VALIDATION_ERROR",
  "message": "입력 정보를 확인해주세요.",
  "error": {
    "type": "ValidationError",
    "details": {
      "email": "올바른 이메일 형식이 아닙니다.",
      "phone": "전화번호는 필수 항목입니다."
    },
    "timestamp": "2024-04-27T12:00:00.000Z"
  }
}
```

#### 401 Unauthorized - 인증 필요
```json
{
  "success": false,
  "code": "AUTH_REQUIRED",
  "message": "로그인이 필요합니다.",
  "error": {
    "type": "AuthenticationError",
    "details": "JWT token이 유효하지 않습니다.",
    "timestamp": "2024-04-27T12:00:00.000Z"
  }
}
```

#### 403 Forbidden - 권한 없음
```json
{
  "success": false,
  "code": "ACCESS_DENIED",
  "message": "접근 권한이 없습니다.",
  "error": {
    "type": "AuthorizationError",
    "details": "관리자만 접근 가능합니다.",
    "timestamp": "2024-04-27T12:00:00.000Z"
  }
}
```

#### 404 Not Found - 리소스 없음
```json
{
  "success": false,
  "code": "NOT_FOUND",
  "message": "요청한 정보를 찾을 수 없습니다.",
  "error": {
    "type": "NotFoundError",
    "details": "ID 123에 해당하는 서비스를 찾을 수 없습니다.",
    "timestamp": "2024-04-27T12:00:00.000Z"
  }
}
```

#### 409 Conflict - 중복/충돌
```json
{
  "success": false,
  "code": "DUPLICATE_REQUEST",
  "message": "이미 진행 중인 요청이 있습니다.",
  "error": {
    "type": "ConflictError",
    "details": "동일한 시간대에 이미 요청이 존재합니다.",
    "timestamp": "2024-04-27T12:00:00.000Z"
  }
}
```

#### 500 Internal Server Error - 서버 오류
```json
{
  "success": false,
  "code": "INTERNAL_ERROR",
  "message": "서버에 일시적인 오류가 발생했습니다. 잠시 후 다시 시도해주세요.",
  "error": {
    "type": "InternalServerError",
    "details": "Database connection failed",
    "timestamp": "2024-04-27T12:00:00.000Z"
  }
}
```

## Backend 구현 가이드

### 1. 응답 유틸리티 클래스

```javascript
// src/utils/response.util.js
class ApiResponse {
  static success(data = null, message = '성공', code = 'SUCCESS', meta = null) {
    return {
      success: true,
      code,
      message,
      data,
      ...(meta && { meta })
    };
  }

  static error(message, code = 'ERROR', type = 'Error', details = null, httpStatus = 500) {
    return {
      success: false,
      code,
      message,
      error: {
        type,
        details,
        timestamp: new Date().toISOString()
      }
    };
  }

  static created(data, message = '생성되었습니다.') {
    return this.success(data, message, 'CREATED');
  }

  static pagination(data, page, limit, total) {
    const meta = {
      page: parseInt(page),
      limit: parseInt(limit),
      total: parseInt(total),
      hasNext: (page * limit) < total
    };
    return this.success(data, '목록을 조회했습니다.', 'SUCCESS', meta);
  }
}

module.exports = ApiResponse;
```

### 2. 커스텀 에러 클래스

```javascript
// src/utils/errors.js
class AppError extends Error {
  constructor(message, code, httpStatus = 500, type = 'Error') {
    super(message);
    this.name = this.constructor.name;
    this.code = code;
    this.httpStatus = httpStatus;
    this.type = type;
    this.isOperational = true;
    
    Error.captureStackTrace(this, this.constructor);
  }
}

class ValidationError extends AppError {
  constructor(message, details = null) {
    super(message, 'VALIDATION_ERROR', 400, 'ValidationError');
    this.details = details;
  }
}

class AuthenticationError extends AppError {
  constructor(message = '인증이 필요합니다.') {
    super(message, 'AUTH_REQUIRED', 401, 'AuthenticationError');
  }
}

class AuthorizationError extends AppError {
  constructor(message = '권한이 없습니다.') {
    super(message, 'ACCESS_DENIED', 403, 'AuthorizationError');
  }
}

class NotFoundError extends AppError {
  constructor(message = '리소스를 찾을 수 없습니다.') {
    super(message, 'NOT_FOUND', 404, 'NotFoundError');
  }
}

class ConflictError extends AppError {
  constructor(message = '요청이 충돌합니다.') {
    super(message, 'DUPLICATE_REQUEST', 409, 'ConflictError');
  }
}

module.exports = {
  AppError,
  ValidationError,
  AuthenticationError,
  AuthorizationError,
  NotFoundError,
  ConflictError
};
```

### 3. 전역 에러 처리 미들웨어

```javascript
// src/middleware/error.middleware.js
const ApiResponse = require('../utils/response.util');
const { AppError } = require('../utils/errors');

const errorHandler = (err, req, res, next) => {
  // 로깅
  console.error('Error:', {
    message: err.message,
    stack: err.stack,
    url: req.url,
    method: req.method,
    body: req.body,
    user: req.user?.id
  });

  // AppError 처리
  if (err instanceof AppError) {
    return res.status(err.httpStatus).json(
      ApiResponse.error(err.message, err.code, err.type, err.details, err.httpStatus)
    );
  }

  // Validation Error (Joi, express-validator 등)
  if (err.name === 'ValidationError') {
    const details = {};
    Object.keys(err.errors).forEach(key => {
      details[key] = err.errors[key].message;
    });
    
    return res.status(400).json(
      ApiResponse.error('입력 정보를 확인해주세요.', 'VALIDATION_ERROR', 'ValidationError', details, 400)
    );
  }

  // JWT Error
  if (err.name === 'JsonWebTokenError') {
    return res.status(401).json(
      ApiResponse.error('토큰이 유효하지 않습니다.', 'INVALID_TOKEN', 'AuthenticationError', null, 401)
    );
  }

  // Database Error
  if (err.name === 'SequelizeConnectionError') {
    return res.status(500).json(
      ApiResponse.error('데이터베이스 연결 오류가 발생했습니다.', 'DB_CONNECTION_ERROR', 'DatabaseError', null, 500)
    );
  }

  // 기타 예상치 못한 에러
  return res.status(500).json(
    ApiResponse.error(
      '서버에 일시적인 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      'INTERNAL_ERROR',
      'InternalServerError',
      process.env.NODE_ENV === 'development' ? err.message : null,
      500
    )
  );
};

module.exports = errorHandler;
```

### 4. Controller 사용 예시

```javascript
// src/controllers/user.controller.js
const ApiResponse = require('../utils/response.util');
const { ValidationError, NotFoundError } = require('../utils/errors');
const userService = require('../services/user.service');

class UserController {
  async getProfile(req, res, next) {
    try {
      const userId = req.user.id;
      const user = await userService.getUserById(userId);
      
      if (!user) {
        throw new NotFoundError('사용자를 찾을 수 없습니다.');
      }

      return res.status(200).json(
        ApiResponse.success(user, '프로필을 조회했습니다.')
      );
    } catch (error) {
      next(error);
    }
  }

  async updateProfile(req, res, next) {
    try {
      const userId = req.user.id;
      const updateData = req.body;

      // 유효성 검사
      if (!updateData.name || updateData.name.length < 2) {
        throw new ValidationError('이름은 2자 이상이어야 합니다.', {
          name: '이름은 2자 이상이어야 합니다.'
        });
      }

      const updatedUser = await userService.updateUser(userId, updateData);

      return res.status(200).json(
        ApiResponse.success(updatedUser, '프로필이 수정되었습니다.')
      );
    } catch (error) {
      next(error);
    }
  }

  async getUserList(req, res, next) {
    try {
      const { page = 1, limit = 10 } = req.query;
      const result = await userService.getUserList(page, limit);

      return res.status(200).json(
        ApiResponse.pagination(result.users, page, limit, result.total)
      );
    } catch (error) {
      next(error);
    }
  }
}

module.exports = new UserController();
```

## Frontend 구현 가이드

### DTO 패턴 강제 사용 (필수)

**모든 API 요청/응답은 반드시 DTO 클래스를 사용해야 함**

#### DTO 명명 규칙
```
요청 DTO: {기능}RequestDto (예: LoginRequestDto, CreateRequestDto)
응답 DTO: {기능}ResponseDto (예: AuthResponseDto, RequestListResponseDto)
```

#### DTO 구조 예시
```dart
// 요청 DTO
class LoginRequestDto {
  final String email;
  final String password;
  
  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}

// 응답 DTO  
class AuthResponseDto {
  final String token;
  final User user;
  
  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthResponseDto(
      token: json['token'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
    );
  }
}
```

#### 환경 설정
```dart
// API Base URL은 환경변수 사용
static const String baseUrl = String.fromEnvironment('API_BASE_URL', 
  defaultValue: 'http://localhost:3000/api/v1');
```

### 1. API 응답 타입 정의

```dart
// lib/core/models/api_response.dart
class ApiResponse<T> {
  final bool success;
  final String code;
  final String message;
  final T? data;
  final ApiError? error;
  final ApiMeta? meta;

  ApiResponse({
    required this.success,
    required this.code,
    required this.message,
    this.data,
    this.error,
    this.meta,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic)? fromJsonT) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null && fromJsonT != null ? fromJsonT(json['data']) : json['data'],
      error: json['error'] != null ? ApiError.fromJson(json['error']) : null,
      meta: json['meta'] != null ? ApiMeta.fromJson(json['meta']) : null,
    );
  }
}

class ApiError {
  final String type;
  final dynamic details;
  final String timestamp;

  ApiError({
    required this.type,
    this.details,
    required this.timestamp,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      type: json['type'] ?? '',
      details: json['details'],
      timestamp: json['timestamp'] ?? '',
    );
  }
}

class ApiMeta {
  final int? page;
  final int? limit;
  final int? total;
  final bool? hasNext;

  ApiMeta({this.page, this.limit, this.total, this.hasNext});

  factory ApiMeta.fromJson(Map<String, dynamic> json) {
    return ApiMeta(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      hasNext: json['hasNext'],
    );
  }
}
```

### 2. HTTP 클라이언트 래퍼

```dart
// lib/core/services/http_client.dart
import 'package:dio/dio.dart';
import '../models/api_response.dart';
import '../exceptions/app_exceptions.dart';

class HttpClient {
  late Dio _dio;

  HttpClient() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://api.gngm.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        final appException = _handleError(error);
        handler.reject(DioException(
          requestOptions: error.requestOptions,
          error: appException,
        ));
      },
    ));
  }

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return ApiResponse<T>.fromJson(response.data, fromJson);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    Map<String, dynamic>? data,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(path, data: data);
      return ApiResponse<T>.fromJson(response.data, fromJson);
    } catch (e) {
      throw _handleError(e);
    }
  }

  AppException _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.response?.statusCode) {
        case 400:
          return ValidationException(
            message: error.response?.data['message'] ?? '잘못된 요청입니다.',
            details: error.response?.data['error']?['details'],
          );
        case 401:
          return AuthenticationException(
            message: error.response?.data['message'] ?? '인증이 필요합니다.',
          );
        case 403:
          return AuthorizationException(
            message: error.response?.data['message'] ?? '권한이 없습니다.',
          );
        case 404:
          return NotFoundException(
            message: error.response?.data['message'] ?? '리소스를 찾을 수 없습니다.',
          );
        case 409:
          return ConflictException(
            message: error.response?.data['message'] ?? '요청이 충돌합니다.',
          );
        case 500:
        default:
          return ServerException(
            message: error.response?.data['message'] ?? '서버 오류가 발생했습니다.',
          );
      }
    }
    
    return NetworkException(message: '네트워크 오류가 발생했습니다.');
  }
}
```

### 3. 예외 클래스 정의

```dart
// lib/core/exceptions/app_exceptions.dart
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  AppException({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() => message;
}

class ValidationException extends AppException {
  ValidationException({
    required String message,
    String? code,
    dynamic details,
  }) : super(message: message, code: code, details: details);
}

class AuthenticationException extends AppException {
  AuthenticationException({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class AuthorizationException extends AppException {
  AuthorizationException({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class NotFoundException extends AppException {
  NotFoundException({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class ConflictException extends AppException {
  ConflictException({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class ServerException extends AppException {
  ServerException({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class NetworkException extends AppException {
  NetworkException({
    required String message,
  }) : super(message: message);
}
```

### 4. Provider에서 에러 처리

```dart
// lib/features/auth/providers/auth_provider.dart
import 'package:flutter/material.dart';
import '../../../core/exceptions/app_exceptions.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  
  bool _isLoading = false;
  String? _error;
  User? _user;

  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get user => _user;
  bool get isAuthenticated => _user != null;

  AuthProvider(this._authService);

  Future<bool> login(String email, String password) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _authService.login(email, password);
      
      if (response.success && response.data != null) {
        _user = response.data;
        notifyListeners();
        return true;
      } else {
        _setError(response.message);
        return false;
      }
    } on ValidationException catch (e) {
      _setError(e.message);
      // 상세 검증 오류 처리
      if (e.details is Map) {
        _showValidationErrors(e.details);
      }
    } on AuthenticationException catch (e) {
      _setError(e.message);
    } on NetworkException catch (e) {
      _setError('네트워크 연결을 확인해주세요.');
    } catch (e) {
      _setError('알 수 없는 오류가 발생했습니다.');
    } finally {
      _setLoading(false);
    }
    
    return false;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void _showValidationErrors(Map<String, dynamic> errors) {
    // 검증 오류 상세 처리 로직
  }
}
```

이렇게 구현하면 백엔드와 프론트엔드 간 일관된 에러 처리와 응답 구조를 유지할 수 있습니다!