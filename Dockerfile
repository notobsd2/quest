FROM node:10
WORKDIR /usr/src/app
COPY quest/package.json ./package.json
RUN npm install
ADD /quest/ .
EXPOSE 3000
ENV SECRET_WORD "This was automatically pushed....." 
CMD ["node", "src/000.js"]
