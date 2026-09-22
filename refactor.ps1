# Refactor script to split monolith into microservices
$baseDir = "c:\e-commerce -Backend"

$services = @("shared-core", "auth-service", "product-service", "vendor-service", "order-service", "notification-service")

foreach ($service in $services) {
    $svcDir = "$baseDir\$service\src\main\java\com\marketgrid\$service"
    New-Item -Path $svcDir -ItemType Directory -Force | Out-Null
    New-Item -Path "$baseDir\$service\src\main\resources" -ItemType Directory -Force | Out-Null
}

# 1. shared-core
Move-Item -Path "$baseDir\src\main\java\com\marketgrid\security" -Destination "$baseDir\shared-core\src\main\java\com\marketgrid\" -Force
# Move global exceptions etc. if any

# 2. auth-service
Move-Item -Path "$baseDir\src\main\java\com\marketgrid\auth" -Destination "$baseDir\auth-service\src\main\java\com\marketgrid\" -Force

# 3. product-service
Move-Item -Path "$baseDir\src\main\java\com\marketgrid\product" -Destination "$baseDir\product-service\src\main\java\com\marketgrid\" -Force

# 4. vendor-service
Move-Item -Path "$baseDir\src\main\java\com\marketgrid\vendor" -Destination "$baseDir\vendor-service\src\main\java\com\marketgrid\" -Force

# 5. order-service
Move-Item -Path "$baseDir\src\main\java\com\marketgrid\order" -Destination "$baseDir\order-service\src\main\java\com\marketgrid\" -Force

# 6. notification-service
Move-Item -Path "$baseDir\src\main\java\com\marketgrid\notification" -Destination "$baseDir\notification-service\src\main\java\com\marketgrid\" -Force

# Create parent pom.xml...
# This is too complex for a single script because of all the POMs.
