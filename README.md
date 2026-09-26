# JavaBank Web App

A Java Servlet/JSP banking web application with account operations, authentication, OTP flows, and notification support.

## Tech Stack

- Java
- Maven
- Servlet + JSP
- MySQL
- Tomcat

## Project Structure

- `src/main/java` - controllers, services, DAO, models, filters, utilities
- `src/main/resources` - environment properties and SQL resources
- `src/main/webapp` - JSP pages and web configuration

## Quick Start

1. Clone the repository.
2. Copy `src/main/resources/application-dev.properties.template` to `src/main/resources/application-dev.properties`.
3. Fill your local values in `application-dev.properties` (DB, mail, app secrets).
4. Create database schema using `src/main/resources/sql/schema_initializer.sql`.
5. Build the app:

```bash
mvn clean package
```

6. Deploy generated WAR to Tomcat.

## Security Note

- Real environment files like `application-dev.properties` are ignored by Git.
- Only template files are committed.
- Local IDE/runtime folders are ignored.

## Repository Hygiene

Ignored paths include:

- `.idea/`
- `.smarttomcat/`
- `target/`
- `src/main/resources/application-*.properties`
- (except) `src/main/resources/application-*.properties.template`
