const fs = require('fs');
const path = require('path');

const baseDir = 'c:\\e-commerce -Backend';

function replaceInFile(filePath, replacements) {
    if (!fs.existsSync(filePath)) return;
    let content = fs.readFileSync(filePath, 'utf8');
    for (const { regex, replacement } of replacements) {
        content = content.replace(regex, replacement);
    }
    fs.writeFileSync(filePath, content, 'utf8');
}

// 1. Order Service -> ProductClient
replaceInFile(path.join(baseDir, 'order-service', 'src', 'main', 'java', 'com', 'marketgrid', 'order', 'OrderService.java'), [
    { regex: /import com\.marketgrid\.product\.ProductService;/g, replacement: 'import com.marketgrid.order.client.ProductClient;' },
    { regex: /private final ProductService productService;/g, replacement: 'private final ProductClient productClient;' },
    { regex: /productService/g, replacement: 'productClient' }
]);

// 2. Order Service -> EmailClient
replaceInFile(path.join(baseDir, 'order-service', 'src', 'main', 'java', 'com', 'marketgrid', 'order', 'OrderService.java'), [
    { regex: /import com\.marketgrid\.notification\.EmailService;/g, replacement: 'import com.marketgrid.order.client.EmailClient;' },
    { regex: /private final EmailService emailService;/g, replacement: 'private final EmailClient emailClient;' },
    { regex: /emailService/g, replacement: 'emailClient' },
    { regex: /sendEmailAsync/g, replacement: 'sendEmail' }
]);

// 3. Auth Service -> EmailClient
replaceInFile(path.join(baseDir, 'auth-service', 'src', 'main', 'java', 'com', 'marketgrid', 'auth', 'AuthService.java'), [
    { regex: /import com\.marketgrid\.notification\.EmailService;/g, replacement: 'import com.marketgrid.auth.client.EmailClient;' },
    { regex: /private final EmailService emailService;/g, replacement: 'private final EmailClient emailClient;' },
    { regex: /emailService/g, replacement: 'emailClient' },
    { regex: /sendEmailAsync/g, replacement: 'sendEmail' }
]);

// 4. Vendor Service -> EmailClient
replaceInFile(path.join(baseDir, 'vendor-service', 'src', 'main', 'java', 'com', 'marketgrid', 'vendor', 'VendorService.java'), [
    { regex: /import com\.marketgrid\.notification\.EmailService;/g, replacement: 'import com.marketgrid.vendor.client.EmailClient;' },
    { regex: /private final EmailService emailService;/g, replacement: 'private final EmailClient emailClient;' },
    { regex: /emailService/g, replacement: 'emailClient' },
    { regex: /sendEmailAsync/g, replacement: 'sendEmail' }
]);

console.log("Replacements done!");
