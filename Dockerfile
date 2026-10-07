# ==========================================
# ESTÁGIO 1: Builder (Compilação e Testes)
# ==========================================
FROM node:22 AS builder

WORKDIR /app

# Copia os arquivos de dependência
COPY package*.json ./

# Instala todas as dependências (incluindo devDependencies para build)
RUN npm ci

# Copia o restante do código fonte
COPY . .

# Executa o build do TypeScript (gera a pasta dist/)
RUN npm run build

# ==========================================
# ESTÁGIO 2: Produção (Imagem Final Enxuta)
# ==========================================
FROM node:22-alpine

WORKDIR /app

# Copia apenas os arquivos de dependência
COPY package*.json ./

# Instala estritamente as dependências de produção e limpa o cache
RUN npm ci --only=production && npm cache clean --force

# Copia apenas a pasta compilada (dist/) do estágio anterior
COPY --from=builder /app/dist ./dist

# SEGURANÇA: Nunca rode containers como root em produção
USER node

# Porta padrão da aplicação
EXPOSE 3000

# Comando para iniciar a aplicação compilada
CMD ["node", "dist/index.js"]