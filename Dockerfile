# Use uma imagem base do Maven com JDK 17 para compilar a aplicação
FROM maven:3.8.4-openjdk-17 AS build

# Defina o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copie o arquivo pom.xml e as dependências do projeto
COPY pom.xml .
COPY src ./src

# Compile o projeto e crie um jar
RUN mvn clean package

# Use uma imagem mais leve com JDK 17 para rodar a aplicação
FROM openjdk:17-jdk-slim

# Defina o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copie o jar do estágio de construção anterior
COPY --from=build /app/target/dsmovie-0.0.1-SNAPSHOT.jar /app/dslist.jar

# Exponha a porta que a aplicação irá rodar
EXPOSE 8080

# Comando para rodar a aplicação
ENTRYPOINT ["java", "-jar", "dslist.jar"]