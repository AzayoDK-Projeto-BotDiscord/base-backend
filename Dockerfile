# Etapa de build
FROM dart:stable AS build

WORKDIR /app

# Copiar pubspec e baixar dependências
COPY pubspec.* ./
RUN dart pub get

# Copiar código fonte
COPY . .

# Compilar o executável
RUN dart compile exe bin/main.dart -o bin/server

# Etapa de produção (imagem mínima)
FROM scratch

# Copiar o executável compilado
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/server

# Copiar arquivo .env (será montado via docker-compose)
COPY --from=build /app/.env /app/.env

WORKDIR /app

EXPOSE 3000

CMD ["/app/bin/server"]
