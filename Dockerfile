# Use Gradle's official image to build the application
FROM gradle:7.6.1-jdk11 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy Gradle build files first (for caching)
COPY build.gradle desktop_app/settings.gradle gradle.properties /app/
COPY gradle /app/gradle

# Pre-download dependencies (speeds up future builds)
RUN gradle dependencies --no-daemon || true

# Copy the full source code
COPY . /app

# Build the WAR file using Gradle
RUN gradle build --no-daemon

#RUN ls -l /app/build/libs/

# Use a lightweight Tomcat image for deployment
FROM tomcat:9.0-jdk11-openjdk-slim

# Set working directory in the runtime container
WORKDIR /usr/local/tomcat/webapps/

# Copy the built WAR file from the Gradle build container
COPY --from=build /app/build/libs/autoinsurance-1.0.0.war ROOT.war

# Expose Tomcat’s default port
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]