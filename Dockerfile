# ---- Build stage ----
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn -q dependency:go-offline
COPY src ./src
RUN mvn -q clean package -DskipTests

# ---- Runtime stage ----
FROM tomcat:10.1-jdk21-temurin
# Remove default Tomcat apps
RUN rm -rf /usr/local/tomcat/webapps/*
# Deploy AceBank as the ROOT application
COPY --from=build /app/target/AceBank.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
# Railway injects a dynamic $PORT; rewrite Tomcat's connector to honor it (default 8080)
CMD ["sh", "-c", "sed -i \"s/port=\\\"8080\\\"/port=\\\"${PORT:-8080}\\\"/\" /usr/local/tomcat/conf/server.xml && catalina.sh run"]

