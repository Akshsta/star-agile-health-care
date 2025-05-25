
FROM maven:3.9.4-eclipse-temurin-17 AS builder

# Set working directory
WORKDIR /app

# Copy Maven project files
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Package the application (skip tests here if you're running them separately in CI)
RUN mvn clean package -DskipTests

# Stage 2: Build minimal runtime image
FROM eclipse-temurin:17-jdk-alpine

# Set working directory inside container
WORKDIR /app

# Copy only the jar from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose port (adjust if needed)
EXPOSE 8080

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
