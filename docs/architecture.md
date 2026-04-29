# GNGM 프로젝트 아키텍처

## 설계 원칙

### 클로드 친화적 설계 원칙
1. **파일당 200라인 이하**: 클로드가 전체 코드를 한 번에 이해할 수 있는 크기
2. **단일 책임 원칙**: 하나의 파일은 하나의 기능만 담당
3. **명확한 네이밍**: 파일명만 봐도 기능을 알 수 있도록
4. **계층 분리**: 비즈니스 로직, UI, 데이터 계층 명확히 구분
5. **일관된 응답/에러 처리**: 모든 API는 표준화된 응답 구조 사용

### API 응답 및 에러 처리 원칙
- **표준화된 응답 구조**: 모든 API 응답은 동일한 형태로 통일
- **전역 에러 처리**: 미들웨어를 통한 중앙 집중식 에러 관리
- **명확한 에러 코드**: 클라이언트가 에러를 구분할 수 있는 커스텀 코드
- **사용자 친화적 메시지**: 기술적 에러를 사용자가 이해할 수 있는 메시지로 변환

**상세 내용**: `/docs/api-standards.md` 참조

## Backend 아키텍처 (Node.js)

### 디렉토리 구조
```
GNGM_BE/
├── src/
│   ├── controllers/          # API 엔드포인트 로직 (150라인 이하)
│   │   ├── auth.controller.js
│   │   ├── user.controller.js
│   │   ├── service.controller.js
│   │   └── chat.controller.js
│   ├── services/            # 비즈니스 로직 (200라인 이하)
│   │   ├── auth.service.js
│   │   ├── user.service.js
│   │   ├── matching.service.js
│   │   └── notification.service.js
│   ├── models/              # 데이터 모델 (100라인 이하)
│   │   ├── user.model.js
│   │   ├── service.model.js
│   │   └── chat.model.js
│   ├── routes/              # 라우트 정의
│   │   ├── auth.routes.js
│   │   ├── user.routes.js
│   │   └── service.routes.js
│   ├── middleware/          # 미들웨어
│   │   ├── auth.middleware.js
│   │   ├── validation.middleware.js
│   │   └── error.middleware.js
│   ├── config/              # 설정
│   │   ├── database.js
│   │   └── constants.js
│   ├── utils/               # 유틸리티
│   │   ├── logger.js
│   │   ├── validator.js
│   │   ├── helpers.js
│   │   ├── response.util.js    # API 응답 표준화
│   │   └── errors.js          # 커스텀 에러 클래스
│   └── app.js              # 앱 초기화
├── tests/                  # 테스트 파일
├── docs/                   # API 문서
└── server.js              # 서버 엔트리포인트
```

### 3-Layer Architecture 패턴
```
┌─────────────────┐
│   Controllers   │ ← HTTP 요청/응답 처리, 입력 검증
├─────────────────┤
│    Services     │ ← 비즈니스 로직, 데이터 처리
├─────────────────┤
│     Models      │ ← 데이터베이스 접근, 스키마 정의
└─────────────────┘
```

### Backend 개발 가이드라인

#### Controller 작성 규칙
- 최대 150라인
- API 엔드포인트 5개 이하
- HTTP 요청/응답 처리만 담당
- 비즈니스 로직은 Service로 위임

#### Service 작성 규칙
- 최대 200라인
- 하나의 주요 비즈니스 도메인만 담당
- 데이터 검증 및 처리
- 다른 Service 호출 가능

#### Model 작성 규칙
- 최대 100라인
- 스키마 정의 + 기본 메서드만
- 복잡한 쿼리는 Service에서 처리

## Frontend 아키텍처 (Flutter)

### 디렉토리 구조
```
GNGM_FE/lib/
├── core/                   # 핵심 기능
│   ├── constants/          # 상수 정의
│   │   ├── colors.dart
│   │   ├── text_styles.dart
│   │   └── api_endpoints.dart
│   ├── models/             # 공통 데이터 모델
│   │   ├── api_response.dart  # API 응답 모델
│   │   └── api_error.dart     # API 에러 모델
│   ├── services/           # API 통신
│   │   ├── http_client.dart   # HTTP 클라이언트 래퍼
│   │   ├── api_service.dart
│   │   ├── auth_service.dart
│   │   └── location_service.dart
│   ├── utils/              # 유틸리티
│   │   ├── validators.dart
│   │   ├── helpers.dart
│   │   └── formatters.dart
│   └── exceptions/         # 예외 처리
│       └── app_exceptions.dart
├── features/               # 기능별 모듈 (Feature-First)
│   ├── auth/               # 인증 기능
│   │   ├── models/
│   │   │   └── user_model.dart
│   │   ├── screens/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── widgets/
│   │   │   └── auth_form.dart
│   │   └── providers/
│   │       └── auth_provider.dart
│   ├── home/               # 홈 화면
│   │   ├── models/
│   │   │   └── service_model.dart
│   │   ├── screens/
│   │   │   └── main_screen.dart
│   │   ├── widgets/
│   │   │   ├── service_card.dart
│   │   │   └── category_item.dart
│   │   └── providers/
│   │       └── service_provider.dart
│   ├── chat/               # 채팅 기능
│   │   ├── models/
│   │   │   └── chat_model.dart
│   │   ├── screens/
│   │   │   └── chat_screen.dart
│   │   └── widgets/
│   │       └── message_bubble.dart
│   └── profile/            # 프로필 기능
│       ├── screens/
│       │   └── profile_screen.dart
│       └── widgets/
│           └── profile_card.dart
├── shared/                 # 공통 컴포넌트
│   ├── widgets/            # 재사용 위젯
│   │   ├── custom_button.dart
│   │   ├── custom_input.dart
│   │   └── loading_indicator.dart
│   └── providers/          # 전역 상태 관리
│       └── app_provider.dart
└── main.dart              # 앱 엔트리포인트
```

### 상태관리: Provider 패턴
- **장점**: 클로드가 이해하기 쉬운 구조
- **예측가능성**: 상태 변화 추적 용이
- **모듈화**: 기능별로 Provider 분리

### Frontend 개발 가이드라인

#### 컴포넌트 재사용성 원칙 (중요)
- **3회 이상 사용 시 공통화 필수**: 동일한 컴포넌트가 3군데 이상 사용되면 반드시 `/shared/widgets/` 디렉토리로 분리
- **재사용 컴포넌트 예시**:
  - 버튼: CustomButton (primary, secondary, text 타입)
  - 카드: ServiceCard, UserCard, InfoCard
  - 입력: CustomInput, SearchInput
  - 모달: AlertModal, ConfirmModal
  - 리스트: CustomListTile, ExpandableListTile
- **Props 인터페이스 명확화**: 재사용을 위한 명확한 속성 정의
- **컴포넌트 문서화**: 사용법과 Props 설명 주석 필수

#### UX 정보 설계 원칙 (중요)
- **정보 축약 및 단계별 제공**: 한 화면에 핵심 정보만 표시 (최대 5-7개 주요 항목)
- **사용자 혼란 방지**: 불필요한 정보나 옵션은 숨기고, 필요 시에만 단계적으로 공개
- **단계별 내비게이션 구조**:
  ```
  메인 화면: 핵심 기능 3-4개만
      ↓
  카테고리 화면: 해당 분야 서비스 리스트
      ↓
  상세 화면: 구체적 정보 및 액션
      ↓
  액션 화면: 최종 처리 (연락, 신청 등)
  ```
- **프로그레시브 디스클로저**: 기본 정보 → 상세 정보 → 추가 액션 순서로 정보 공개

#### Screen 작성 규칙
- 최대 300라인
- 하나의 화면만 담당
- 복잡한 UI는 Widget으로 분리
- 상태 관리는 Provider 사용
- **정보 밀도**: 한 화면에 최대 5-7개 주요 정보만 표시

#### Widget 작성 규칙
- 최대 200라인
- 단일 UI 컴포넌트만 담당
- 재사용 가능하게 설계
- Props를 통한 데이터 전달
- **3회 이상 사용 시 shared/widgets로 이동 필수**

#### Provider 작성 규칙
- 최대 200라인
- 하나의 도메인 상태만 관리
- 비즈니스 로직 포함 가능
- API 호출 및 에러 처리

## 개발 워크플로우

### 새 기능 추가 순서
1. **모델 정의**: 데이터 구조 먼저 설계
2. **백엔드 구현**: Model → Service → Controller → Route
3. **프론트엔드 구현**: Model → Provider → Screen → Widget
4. **통합 테스트**: API 연동 확인

### 파일 분할 기준
- **라인 수 초과**: 200라인(BE), 300라인(FE) 초과 시 분할
- **기능 분리**: 서로 다른 책임은 별도 파일
- **재사용성**: 공통 로직은 유틸리티/shared로 분리

### 클로드 작업 최적화 팁
- 한 번에 하나의 파일만 수정
- 파일 간 의존성 최소화
- 명확한 인터페이스 정의
- 주석을 통한 의도 명시

## 코딩 컨벤션

### 파일 명명 규칙
```
Backend:
- user.controller.js
- auth.service.js
- chat.model.js

Frontend:
- login_screen.dart
- service_card.dart
- auth_provider.dart
```

### 클래스/함수 명명 규칙
```javascript
// Backend (camelCase)
class UserController {
  async getUserProfile() {}
}

// Frontend (PascalCase for classes, camelCase for methods)
class ServiceCard extends StatelessWidget {
  void onCardTap() {}
}
```

## 데이터 플로우

### Backend API 플로우
```
Request → Route → Middleware → Controller → Service → Model → Database
Response ← Route ← Controller ← Service ← Model ← Database
```

### Frontend 데이터 플로우
```
UI Event → Widget → Provider → API Service → Backend
UI Update ← Widget ← Provider ← API Service ← Backend
```

## 에러 처리 전략

### Backend 에러 처리
- Middleware에서 중앙 집중식 에러 처리
- 커스텀 에러 클래스 사용
- 로깅 및 모니터링

### Frontend 에러 처리
- Provider에서 에러 상태 관리
- 사용자 친화적 에러 메시지
- 네트워크 에러 대응

이 아키텍처를 따라 개발하면 유지보수성이 높고 클로드가 효율적으로 작업할 수 있는 코드베이스를 구축할 수 있습니다.