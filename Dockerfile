FROM node:18.14 AS dependencies
WORKDIR /home/app

COPY package.json ./
COPY package-lock.json ./
RUN npm install

FROM node:18 AS builder
WORKDIR /home/app

COPY --from=dependencies /home/app/node_modules ./node_modules
COPY . .

ENV NODE_ENV="production"

FROM node:18 AS runner
WORKDIR /home/app

COPY --from=builder /home/app/server /home/app/server
COPY --from=builder /home/app/public /home/app/public


ENV NODE_ENV="production"
EXPOSE 3000
ENV PORT 3000


CMD ["node", "./server/index.js"]