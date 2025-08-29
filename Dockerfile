# Estágio 1: Instalar dependências e construir
FROM node:18-alpine AS builder

WORKDIR /usr/src/app

# Instala o cliente do postgres para o healthcheck funcionar
RUN apk add --no-cache postgresql-client

COPY package*.json ./
RUN npm install

COPY . .

# Gera o cliente Prisma
RUN npx prisma generate

# Estágio 2: Imagem final, otimizada para produção
FROM node:18-alpine

WORKDIR /usr/src/app

# Copia o cliente postgres do estágio anterior
RUN apk add --no-cache postgresql-client

# Copia as dependências instaladas do estágio anterior
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/package*.json ./

# Copia o código da aplicação e o cliente prisma gerado
COPY --from=builder /usr/src/app .

# Garante que o script de inicialização é executável
RUN chmod +x /usr/src/app/docker-entrypoint.sh

# Define o script como o ponto de entrada do contêiner
ENTRYPOINT ["/usr/src/app/docker-entrypoint.sh"]

# Expõe a porta que o servidor usa
EXPOSE 8000

# Comando padrão que será executado pelo entrypoint
CMD ["npm", "start"]