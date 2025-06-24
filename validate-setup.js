#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

console.log('=== Umbrel App Store Validation ===\n');

// Check umbrel-app-store.yml
const appStoreYmlPath = path.join(__dirname, 'umbrel-app-store.yml');
if (fs.existsSync(appStoreYmlPath)) {
    const content = fs.readFileSync(appStoreYmlPath, 'utf8');
    console.log('✓ umbrel-app-store.yml exists');
    console.log('Content:');
    console.log(content);
    
    // Basic validation
    if (content.includes('id:') && content.includes('name:')) {
        console.log('✓ Contains required id and name fields\n');
    } else {
        console.log('✗ Missing required id or name fields\n');
    }
} else {
    console.log('✗ umbrel-app-store.yml not found\n');
}

// Check app directory structure
const dirs = fs.readdirSync(__dirname, { withFileTypes: true })
    .filter(dirent => dirent.isDirectory())
    .map(dirent => dirent.name);

console.log('App directories found:', dirs);

for (const dir of dirs) {
    if (dir.startsWith('.') || dir === 'node_modules') continue;
    
    console.log(`\n--- Checking app: ${dir} ---`);
    
    const appDir = path.join(__dirname, dir);
    const umbrelAppYml = path.join(appDir, 'umbrel-app.yml');
    const dockerCompose = path.join(appDir, 'docker-compose.yml');
    
    if (fs.existsSync(umbrelAppYml)) {
        console.log('✓ umbrel-app.yml exists');
        const content = fs.readFileSync(umbrelAppYml, 'utf8');
        if (content.includes('manifestVersion:') && content.includes('id:')) {
            console.log('✓ Basic umbrel-app.yml structure valid');
        } else {
            console.log('✗ umbrel-app.yml missing required fields');
        }
    } else {
        console.log('✗ umbrel-app.yml not found');
    }
    
    if (fs.existsSync(dockerCompose)) {
        console.log('✓ docker-compose.yml exists');
    } else {
        console.log('✗ docker-compose.yml not found');
    }
}

console.log('\n=== Validation Complete ===');
