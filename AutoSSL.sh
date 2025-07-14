#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}This script must be run as root.${NC}"
   exit 1
fi

echo -e "${GREEN}Installing acme.sh ...${NC}"
curl https://get.acme.sh | sh
source ~/.bashrc

read -p $'\033[0;32mEnter your domain (e.g. sub.domain.com): \033[0m' DOMAIN
read -p $'\033[0;32mEnter your email for Let'\''s Encrypt registration: \033[0m' EMAIL

SSL_DIR="/root/cert/$DOMAIN"

echo "Requesting certificate for $DOMAIN using standalone mode ..."
~/.acme.sh/acme.sh --issue -d "$DOMAIN" --standalone --email "$EMAIL" --force

echo "Saving keys to $SSL_DIR ..."
mkdir -p "$SSL_DIR"

~/.acme.sh/acme.sh --install-cert -d "$DOMAIN" \
--key-file "$SSL_DIR/private.pem" \
--fullchain-file "$SSL_DIR/public.pem"

echo -e "${GREEN}Done!${NC}"
echo -e "${YELLOW}Private key: $SSL_DIR/private.pem${NC}"
echo -e "${YELLOW}Certificate: $SSL_DIR/public.pem${NC}"
