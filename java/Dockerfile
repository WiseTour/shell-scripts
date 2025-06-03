# Usa imagem base com Java 21
FROM eclipse-temurin:21-jdk

# Define o diretório de trabalho
WORKDIR /app

# Instala Git e Maven
RUN apt-get update && apt-get install -y git maven

# Clona o repositório
RUN git clone https://github.com/WiseTour/etl.git

# Copia o arquivo de configuração local para dentro do container
COPY config.properties /app/config.properties

# Define o diretório onde está o projeto
WORKDIR /app/etl

# Compila o projeto (sem rodar testes)
RUN mvn clean package -DskipTests

# Expõe a porta usada pela aplicação
EXPOSE 8080

# Executa o JAR gerado com o arquivo de configuração como argumento
ENTRYPOINT ["java", "-jar", "target/etl-1.0-SNAPSHOT-jar-with-dependencies.jar", "../config.properties"]
