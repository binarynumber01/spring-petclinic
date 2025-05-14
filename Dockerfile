# 1단계: Maven으로 빌드
FROM maven:3.9.6-eclipse-temurin-17 AS builder

# 작업 디렉터리 설정
WORKDIR /app

# 프로젝트의 의존성 파일 복사 및 의존성 설치
COPY pom.xml .
RUN mvn dependency:go-offline

# 나머지 소스 복사 후 빌드
COPY src ./src
RUN mvn clean package -DskipTests

# 2단계: 실행 환경 (경량 JDK)
FROM eclipse-temurin:17-jdk-alpine

# 작업 디렉터리 설정
WORKDIR /app

# 빌드된 JAR 파일 복사
COPY --from=builder /app/target/*.jar app.jar

# JAR 파일 실행
ENTRYPOINT ["java", "-jar", "app.jar"]
