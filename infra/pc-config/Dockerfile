FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY target/*.jar app.jar
COPY config-repo /app/config-repo
ENV CONFIG_REPO_LOCATION=file:/app/config-repo
EXPOSE 18888
ENTRYPOINT ["java", "-jar", "app.jar"]