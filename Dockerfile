# --- FASE 1: Construção (Build) ---
FROM node:18-alpine AS builder
WORKDIR /app
# Copia arquivos de dependências
COPY package*.json ./
# Instala as dependências
RUN npm install
# Copia o restante do código
COPY . .
# Cria a pasta 'dist' ou 'build' com o site otimizado
RUN npm run build

# --- FASE 2: Servidor Web (Nginx) ---
FROM nginx:alpine
# Copia o que foi construído na fase 1 para dentro do servidor Nginx
# Se o seu projeto usa 'npm run build', a pasta pode ser 'build' ou 'dist'. Verifique qual pasta é gerada no seu PC.
COPY --from=builder /app/dist /usr/share/nginx/html
# Configuração para o React funcionar bem com rotas (SPA)
RUN echo 'server { listen 80; location / { root /usr/share/nginx/html; index index.html; try_files $uri $uri/ /index.html; } }' > /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]