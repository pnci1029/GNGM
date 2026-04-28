FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Flutter 설정
RUN flutter config --no-analytics
RUN flutter config --enable-web

# 의존성 설치
COPY pubspec*.yaml ./
RUN flutter pub get

# 소스 복사 및 빌드
COPY . .
RUN flutter build web --release

# Nginx로 서빙
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]