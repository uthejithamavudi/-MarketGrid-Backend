# MarketGrid Multi-Vendor E-Commerce Platform Backend

MarketGrid is an enterprise-grade, highly scalable Multi-Vendor E-Commerce Platform backend built with **Java 17+ (Java 21 support)**, **Spring Boot 3.2.x**, **Spring Cloud (Gateway, Eureka)**, **Spring Data MongoDB**, **Spring Security (JWT, RBAC)**, and **Spring Boot Mail (`JavaMailSender` + Thymeleaf HTML templates)**.

---

## 🏛️ Architecture Overview

```
                      +-----------------------------------+
                      |   Next.js / Vite Frontend (5173)  |
                      +-----------------+-----------------+
                                        |
                                        v
                    +-------------------+-------------------+
                    |  Spring Cloud API Gateway (Port 8080) |
                    +-------------------+-------------------+
                                        |
      +-----------------+---------------+---------------+-----------------+
      |                 |               |               |                 |
      v                 v               v               v                 v
+-----------+     +-----------+   +-----------+   +-----------+   +---------------+
| Auth Svc  |     | Product   |   | Vendor    |   | Order Svc |   | Notification  |
| (8081)    |     | Svc (8082)|   | Svc (8083)|   | (8084)    |   | Svc (8085)    |
+-----+-----+     +-----+-----+   +-----+-----+   +-----+-----+   +-------+-------+
      |                 |               |               |                 |
      v                 v               v               v                 v
+-----------+     +-----------+   +-----------+   +-----------+   +---------------+
| auth_db   |     | product_db|   | vendor_db |   | order_db  |   |notification_db|
+-----------+     +-----------+   +-----------+   +-----------+   +---------------+
```

---

## 📦 Microservices Breakdown

| Service Name | Port | Description | Database |
| :--- | :--- | :--- | :--- |
| **`eureka-server`** | `8761` | Netflix Eureka Service Registry & Health Dashboard | N/A |
| **`api-gateway`** | `8080` | Spring Cloud Gateway & Centralized JWT Validation | N/A |
| **`auth-service`** | `8081` | User Identity, RBAC, JWT tokens, 6-digit OTP verification | `auth_db` |
| **`product-service`** | `8082` | Product Catalog, Search, Categories, Inventory stock reservation | `product_db` |
| **`vendor-service`** | `8083` | Merchant Onboarding, KYC Approval, Store Profile | `vendor_db` |
| **`order-service`** | `8084` | Cart, Multi-Vendor Sub-Order Splitting Engine, Checkout | `order_db` |
| **`notification-service`**| `8085` | Async `JavaMailSender` + Thymeleaf HTML Email Templates | `notification_db` |

---

## 🚀 Quick Start Guide

### Prerequisites
1. **JDK 17+** (Java 21 installed and supported)
2. **Apache Maven 3.8+**
3. **MongoDB** (running on port `27017` or via Docker)

### Build & Package
```bash
mvn clean package -DskipTests
```

### Run Locally
1. Start MongoDB:
   Ensure MongoDB is active on `mongodb://localhost:27017`.
2. Launch Services in order:
   - `eureka-server` (`8761`)
   - `api-gateway` (`8080`)
   - `auth-service` (`8081`)
   - `product-service` (`8082`)
   - `vendor-service` (`8083`)
   - `order-service` (`8084`)
   - `notification-service` (`8085`)

Or run via Docker Compose:
```bash
docker-compose up --build
```
