# GNGM - 가는김에

"가는김에" - 지역 커뮤니티 기반의 배송/심부름 서비스

## 📋 프로젝트 문서

### 핵심 문서
- **[아키텍처 가이드](docs/architecture.md)**: 프로젝트 구조 및 개발 원칙
- **[시크릿 관리](docs/secrets-management.md)**: 보안 설정 및 외부 서비스 연동
- **[개발 워크플로우](docs/development-workflow.md)**: 16주 개발 계획 및 공수 산정
- **[API 표준](docs/api-standards.md)**: API 응답 구조 및 에러 처리

### 디자인 시스템
- **[CLAUDE.md](CLAUDE.md)**: 디자인 가이드라인 및 UI/UX 원칙

## 🚀 빠른 시작

### 1. 환경 설정
```bash
# 저장소 클론
git clone https://github.com/your-username/GNGM.git
cd GNGM

# 시크릿 설정 (docs/secrets-management.md 참조)
mkdir ../playground
# playground/backend-secrets.env 및 frontend-secrets.dart 설정

# 시크릿 동기화
node sync-secrets.js
```

### 2. 개발 환경 실행
```bash
# Docker로 실행
docker-compose up --build

# 또는 개별 실행
cd GNGM_BE && npm run dev
cd GNGM_FE && flutter run -d chrome
```

### 3. 접속
- **Frontend**: http://localhost:3001
- **Backend**: http://localhost:3000
- **API Health**: http://localhost:3000/health

## 🛠 기술 스택

### Frontend (Flutter)
- **Flutter**: 크로스 플랫폼 모바일 앱
- **Google Fonts**: Jua 폰트 (따뜻한 커뮤니티 감성)
- **Provider**: 상태 관리

### Backend (Node.js)
- **Express**: REST API 서버
- **Sequelize**: PostgreSQL ORM
- **JWT**: 인증 토큰
- **Bcrypt**: 비밀번호 암호화

### 개발 도구
- **Docker**: 컨테이너 개발 환경
- **ESLint + Prettier**: 코드 품질 관리
- **GitHub Actions**: CI/CD 파이프라인

## 🎯 핵심 기능

### 서비스 카테고리
- 🛒 **장보기**: 마트/편의점 대신 구매
- 📦 **배송**: 택배/문서 전달  
- 🚗 **이동**: 같은 방향 동행
- 👥 **함께가기**: 병원, 관공서 동행

### 신뢰 시스템
- ✅ OAuth 인증 (카카오, 구글)
- ⭐ 상호 평가 및 신뢰 점수
- 💬 실시간 채팅
- 📍 지도 기반 서비스 매칭

## 🏗 아키텍처 특징

### 클로드 친화적 설계
- **파일 크기 제한**: BE 200라인, FE 300라인
- **단일 책임 원칙**: 각 파일은 하나의 기능만 담당
- **컴포넌트 재사용**: 3회 이상 사용 시 공통화 필수
- **정보 축약**: 한 화면에 최대 5-7개 핵심 정보만

### 보안
- **시크릿 분리**: Git 외부 playground에서 민감 정보 관리
- **자동 동기화**: sync-secrets.js로 원클릭 동기화
- **환경별 설정**: 개발/테스트/운영 환경 분리

## 📈 개발 현황

**Phase 1 완료**: 개발 환경 구축 ✅
- Docker 환경, CI/CD, 코드 품질 도구
- 시크릿 관리 시스템
- 소프트 민트 그린 디자인 시스템 + Jua 폰트

**Phase 2 완료**: 데이터베이스 설계 ✅  
- User 모델 (OAuth, 평점, 위치)
- ServiceRequest 모델 (카테고리별 서비스)
- Sequelize ORM 설정

**다음**: Phase 3 백엔드 API 개발

## 🤝 기여하기

1. 반드시 [아키텍처 가이드](docs/architecture.md) 숙지
2. [시크릿 설정](docs/secrets-management.md) 완료
3. 코드 작성 전 `npm run lint` 실행
4. 컴포넌트 재사용성 원칙 준수

## 📄 라이선스

MIT License