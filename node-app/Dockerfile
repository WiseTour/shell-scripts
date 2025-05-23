FROM node:18

# Clona o repositório
RUN git clone https://github.com/WiseTour/wise-tour.git app

WORKDIR /app

COPY .env.dev app/env.dev

# Instala as dependências
RUN npm install

# Expõe a porta que a aplicação usa
EXPOSE 3333

# Executa a aplicação
CMD ["npm", "start"]
