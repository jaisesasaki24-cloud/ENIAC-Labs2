FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 18761
ENTRYPOINT ["java", "-jar", "app.jar"]