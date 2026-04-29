# 시크릿 관리 및 외부 서비스 설정

## 개요
GNGM 프로젝트는 보안을 위해 별도의 시크릿 관리 시스템을 사용합니다. 실제 API 키, 데이터베이스 비밀번호 등의 민감한 정보는 Git 저장소에 포함되지 않습니다.

## 필요한 외부 서비스

### 1. 카카오 개발자 계정
- **URL**: https://developers.kakao.com
- **설정**: 앱 생성, 카카오 로그인 활성화, Redirect URI 설정
- **필요한 키**: KAKAO_CLIENT_ID, KAKAO_CLIENT_SECRET, KAKAO_MAP_API_KEY

### 2. 구글 개발자 콘솔
- **URL**: https://console.cloud.google.com
- **설정**: OAuth 2.0 클라이언트 생성, 동의 화면 설정
- **필요한 키**: GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET

### 3. 네이버 지도 API
- **URL**: https://www.ncloud.com/product/applicationService/maps
- **필요한 키**: NAVER_MAP_CLIENT_ID, NAVER_MAP_CLIENT_SECRET

### 4. Firebase (FCM)
- **URL**: https://console.firebase.google.com
- **필요한 키**: FIREBASE_SERVER_KEY, FIREBASE_PROJECT_ID

### 5. AWS/NCP 클라우드
- **필요한 키**: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY

## 디렉토리 구조

```
GNGM/
├── playground/                    # Git에 포함되지 않음
│   ├── backend-secrets.env        # 백엔드 시크릿
│   └── frontend-secrets.dart      # 프론트엔드 시크릿
├── sync-secrets.js               # 시크릿 동기화 스크립트
├── GNGM_BE/
│   └── .env                      # 동기화된 백엔드 환경변수 (Git 무시)
└── GNGM_FE/
    └── lib/core/constants/
        └── app_secrets.dart      # 동기화된 프론트엔드 시크릿 (Git 무시)
```

## 설정 방법

### 1. Playground 디렉토리 설정
```bash
# GNGM 프로젝트와 같은 레벨에 playground 디렉토리 생성
cd /path/to/your/projects
mkdir playground
cd playground
```

### 2. 시크릿 파일 생성

#### Backend Secrets (`playground/backend-secrets.env`)
```bash
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/gngm_db
JWT_SECRET=your-actual-jwt-secret-key

# OAuth
KAKAO_CLIENT_ID=your-real-kakao-client-id
GOOGLE_CLIENT_SECRET=your-real-google-secret

# API Keys
NAVER_MAP_CLIENT_ID=your-naver-map-id
FIREBASE_SERVER_KEY=your-firebase-server-key
```

#### Frontend Secrets (`playground/frontend-secrets.dart`)
```dart
class AppSecrets {
  static const String kakaoMapApiKey = 'your-real-kakao-map-key';
  static const String firebaseProjectId = 'your-firebase-project-id';
  static const String baseUrl = 'https://your-production-domain.com';
}
```

## 사용법

### 시크릿 동기화
```bash
# 백엔드 디렉토리에서
cd GNGM_BE
npm run sync

# 또는 루트 디렉토리에서
node sync-secrets.js
```

### 상태 확인
```bash
cd GNGM_BE
npm run secrets:status

# 또는
node sync-secrets.js status
```

### 사용 가능한 명령어
```bash
node sync-secrets.js            # 시크릿 동기화 (기본)
node sync-secrets.js sync       # 시크릿 동기화
node sync-secrets.js status     # 현재 상태 확인
node sync-secrets.js help       # 도움말 표시
```

## 시크릿 파일 템플릿

프로젝트에 다음 템플릿들이 포함되어 있습니다:
- `GNGM_BE/.env.example` - 백엔드 환경변수 템플릿
- `playground/` 디렉토리의 템플릿 파일들

## 보안 주의사항

### ✅ 안전한 방법
- `playground/` 디렉토리는 Git 저장소 밖에 위치
- 실제 시크릿 값은 절대 Git에 커밋하지 않음
- `.env`와 `app_secrets.dart`는 `.gitignore`에 포함됨

### ❌ 피해야 할 것
- 시크릿 파일을 Git에 추가하지 말 것
- 코드에 하드코딩하지 말 것
- 공개 채널에서 시크릿 정보 공유하지 말 것

## 개발 환경별 설정

### 개발 (Development)
```bash
NODE_ENV=development
DATABASE_URL=postgresql://localhost:5432/gngm_dev
```

### 테스트 (Test)
```bash
NODE_ENV=test
DATABASE_URL=postgresql://localhost:5432/gngm_test
```

### 운영 (Production)
```bash
NODE_ENV=production
DATABASE_URL=postgresql://prod-server:5432/gngm_prod
```

## 팀 협업 가이드

### 새 팀원 온보딩
1. `playground/` 디렉토리를 로컬에 생성
2. 시크릿 템플릿 파일들을 복사
3. 실제 개발용 시크릿 값들로 교체 (별도 전달)
4. `npm run sync` 실행하여 동기화

### 시크릿 값 공유
- 보안 채널을 통해서만 공유 (예: 암호화된 메시지, 보안 저장소)
- 절대 Git, 이메일, 메신저에 직접 포함하지 않음

## 트러블슈팅

### 동기화 실패
```bash
# 권한 확인
chmod +x sync-secrets.js

# 경로 확인
node sync-secrets.js status
```

### 파일 누락
```bash
# 템플릿에서 복사
cp GNGM_BE/.env.example playground/backend-secrets.env
```

### 환경변수 로드 실패
```bash
# .env 파일 존재 확인
ls -la GNGM_BE/.env

# 동기화 재실행
npm run sync
```

## 자동화 (선택사항)

### Pre-commit Hook
```bash
#!/bin/sh
# .git/hooks/pre-commit
node sync-secrets.js
```

### IDE 통합
- VSCode: 터미널에서 `npm run sync` 실행
- 빌드 프로세스에 자동 동기화 포함 가능

이 시스템을 통해 보안을 유지하면서 효율적으로 시크릿을 관리할 수 있습니다.