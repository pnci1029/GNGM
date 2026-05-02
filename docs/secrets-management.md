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

### ✅ 반드시 지켜야 할 규칙
- **환경변수만 사용**: 모든 설정 정보는 process.env에서만 가져오기
- **하드코딩 금지**: `||` 연산자로 기본값 노출 절대 금지
- **필수 검증**: 환경변수 누락 시 애플리케이션 시작 실패하도록 구현
- **playground 분리**: Git 저장소 밖에 시크릿 정보 보관
- **.gitignore 완전성**: 모든 민감 파일 경로 차단

### ❌ 절대 금지사항
```javascript
// ❌ 잘못된 예시 - 하드코딩 노출
const PORT = process.env.PORT || 3000;
const DB_HOST = process.env.DB_HOST || 'localhost';

// ✅ 올바른 예시 - 환경변수만 사용
if (!process.env.PORT) {
  throw new Error('Missing required environment variable: PORT');
}
const PORT = parseInt(process.env.PORT, 10);
```

### 🚨 코딩 규칙 (필수 준수)
1. **환경변수 검증 필수**: 모든 설정 파일에서 필수 환경변수 존재 여부 확인
2. **기본값 금지**: `||` 연산자로 기본값 제공 금지
3. **타입 변환**: 숫자형 환경변수는 반드시 parseInt() 사용
4. **에러 처리**: 환경변수 누락 시 명확한 에러 메시지와 함께 종료
5. **문서화**: 새로운 환경변수 추가 시 반드시 playground 템플릿 업데이트

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