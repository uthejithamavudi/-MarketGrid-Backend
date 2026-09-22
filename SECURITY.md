# Security Policy

## Responsible Disclosure & Scope

MarketGrid takes security and user data privacy seriously. This document outlines our vulnerability handling policies and security guidelines for the platform.

### Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

### Security Measures Implemented
- **JSON Web Tokens (JWT)**: HMAC SHA-256 signed access tokens (15m expiry) and refresh tokens (7d expiry).
- **Password Hashing**: BCrypt password encoder with salt strength 12.
- **Role-Based Access Control (RBAC)**: Fine-grained method security (`ROLE_CUSTOMER`, `ROLE_VENDOR`, `ROLE_ADMIN`).
- **OTP Verification**: Cryptographically secure 6-digit verification code with 5-minute window and 3-attempt lockout.
- **Clean Gateway Filtering**: Intercepts requests, validates signatures, and strips unauthorized claim headers.
- **Environment Driven Secrets**: Zero hardcoded credentials or API keys.

## Reporting a Vulnerability

If you discover a security vulnerability within MarketGrid, please notify our security team directly:
- **Email**: `security@marketgrid.com`
- **Response SLA**: Initial triage within 24 hours.
