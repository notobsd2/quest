FROM node:10
WORKDIR /usr/src/app
COPY quest/package.json ./package.json
RUN npm install
ADD /quest/ .
EXPOSE 3000
ENV SECRET_WORD "SSL works and this is also through a load balancer, as you can see from the URL" 
CMD ["node", "src/000.js"]
