# ── Build stage ──────────────────────────────────────────────
# Dùng Maven + JDK 21 để build file .jar
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copy pom trước để tận dụng cache dependency
COPY pom.xml .
COPY .mvn/ .mvn/
RUN mvn dependency:go-offline -B

# Copy source và build (bỏ qua test cho nhanh)
COPY src/ src/
RUN mvn clean package -DskipTests -B

# ── Run stage ────────────────────────────────────────────────
# Image gọn nhẹ chỉ chứa JRE để chạy app
FROM eclipse-temurin:21-jre
WORKDIR /app

# Copy file jar đã build từ stage trước
COPY --from=build /app/target/*.jar app.jar

# Render sẽ inject biến PORT; Spring đọc qua server.port=${PORT}
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
