#!/bin/bash

echo "=== Safford Equipment Development Installer ==="

WP_DIR="./wordpress"
PLUGINS_DIR="$WP_DIR/wp-content/plugins"
THEMES_DIR="$WP_DIR/wp-content/themes"

mkdir -p $PLUGINS_DIR
mkdir -p $THEMES_DIR

echo ""
echo "=== Building and Starting Docker Containers ==="

docker compose build
docker compose up -d

echo "[+] Docker containers started."

echo ""
echo "=== Cleaning plugins folder ==="

# Ștergem TOT din plugins, DAR păstrăm index.php dacă există
find $PLUGINS_DIR -mindepth 1 ! -name "index.php" -exec rm -rf {} +

echo "[+] Plugins folder cleaned."

echo ""
echo "=== Installing Plugins ==="

PLUGIN_REPO="git@github.com:saffordbrands/safford-equipment-dev-plugins.git"
TEMP_DIR="./temp-plugins"

# Ștergem temp dacă există
rm -rf $TEMP_DIR

# Clone repo în folder temporar
git clone $PLUGIN_REPO $TEMP_DIR

# Mutăm conținutul DIRECT în plugins/
mv $TEMP_DIR/* $PLUGINS_DIR/

# Ștergem temp
rm -rf $TEMP_DIR

echo "[+] Plugins installed successfully."

echo ""
echo "=== Installing Theme ==="

THEME_REPO="git@github.com:woocommerce/storefront.git"
THEME_TARGET="$THEMES_DIR/storefront"

if [ ! -d "$THEME_TARGET" ]; then
    echo "[+] Cloning Storefront theme..."
    git clone $THEME_REPO $THEME_TARGET
else
    echo "[i] Theme exists — pulling updates..."
    cd $THEME_TARGET
    git pull
    cd -
fi

echo ""
echo "=== Restarting Wordpress container to load plugins ==="

docker compose restart wordpress

echo ""
echo "=== DONE ==="

echo "--------------------------------------------"
echo " WordPress:     http://localhost:8080"
echo " phpMyAdmin:    http://localhost:8081"
echo "--------------------------------------------"
