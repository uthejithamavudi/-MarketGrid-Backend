# Stage 1: Build the Microservices
FROM maven:3.9.6-eclipse-temurin-21-alpine AS builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Stage 2: Create the minimal runtime image
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Copy all the compiled jars from the builder stage
COPY --from=builder /app/eureka-server/target/*.jar /app/eureka.jar
COPY --from=builder /app/api-gateway/target/*.jar /app/gateway.jar
COPY --from=builder /app/auth-service/target/*.jar /app/auth.jar
COPY --from=builder /app/product-service/target/*.jar /app/product.jar
COPY --from=builder /app/vendor-service/target/*.jar /app/vendor.jar
COPY --from=builder /app/order-service/target/*.jar /app/order.jar
COPY --from=builder /app/notification-service/target/*.jar /app/notification.jar

# Expose the API Gateway port (Render sets the PORT environment variable)
EXPOSE 8080

# By default, run the gateway if no command is specified. 
# Render Blueprint (render.yaml) will override this command for the other 6 services!
CMD ["sh", "-c", "java -Xmx256m -jar /app/gateway.jar --server.port=${PORT:-8080}"]
