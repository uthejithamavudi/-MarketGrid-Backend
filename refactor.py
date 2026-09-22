import os
import shutil
import re

base_dir = "c:\\e-commerce -Backend"
src_main_java = os.path.join(base_dir, "src", "main", "java", "com", "marketgrid")
services = ["auth", "product", "vendor", "order", "notification"]

# 1. Create directory structure
for svc in services:
    svc_dir = os.path.join(base_dir, f"{svc}-service", "src", "main", "java", "com", "marketgrid", svc)
    os.makedirs(svc_dir, exist_ok=True)
    os.makedirs(os.path.join(base_dir, f"{svc}-service", "src", "main", "resources"), exist_ok=True)

# Also create shared-core
shared_dir = os.path.join(base_dir, "shared-core", "src", "main", "java", "com", "marketgrid")
os.makedirs(shared_dir, exist_ok=True)

# 2. Move files
# Move security to shared-core
if os.path.exists(os.path.join(src_main_java, "security")):
    shutil.move(os.path.join(src_main_java, "security"), shared_dir)

# Move each service package
for svc in services:
    src_pkg = os.path.join(src_main_java, svc)
    if os.path.exists(src_pkg):
        dst_pkg = os.path.join(base_dir, f"{svc}-service", "src", "main", "java", "com", "marketgrid", svc)
        # We merge them if they already exist, but here we just copy/move
        for item in os.listdir(src_pkg):
            shutil.move(os.path.join(src_pkg, item), dst_pkg)

# 3. Create POM files
# We will create a basic pom.xml for each service and shared-core
# (Skipped in this basic script, will write separate pom.xml files)

print("Files moved successfully!")
