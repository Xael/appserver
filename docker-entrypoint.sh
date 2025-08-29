#!/bin/sh

# Sair imediatamente se um comando falhar
set -e

echo "Running database migrations..."
# 'migrate deploy' é o comando recomendado para ambientes de produção/CI/CD
npx prisma migrate deploy

echo "Migrations complete. Starting the application..."

# Executa o comando principal que foi passado para o script
# (neste caso, será "npm start" do Dockerfile)
exec "$@"