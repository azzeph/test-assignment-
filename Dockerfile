# Используем многоэтапную сборку для уменьшения итогового образа
FROM maven:3.8.5-openjdk-17 AS builder

# Копируем только pom.xml сначала для кэширования зависимостей и грамотно распределяем слои 
WORKDIR /app
COPY pom.xml .
# Скачиваем зависимости 
RUN mvn dependency:go-offline

# Копируем исходный код и собираем приложение
COPY src ./src
RUN mvn package -DskipTests

# Этап 2: Образ для запуска приложения 
FROM eclipse-temurin:17-jre-alpine

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем собранный JAR из этапа сборки
COPY --from=builder /app/target/*.jar app.jar

# Переменную можно переопределить, что избавляет нас от необходимости пересборки, если параметры запуска нужно изменить 
ENV JAVA_OPTS="-Xms128m -Xmx512m"

# Используем non-root пользователя для безопасности
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Открываем порт
EXPOSE 8080

# Запускаем приложение
ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar /app/app.jar"]
