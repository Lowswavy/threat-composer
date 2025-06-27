FROM node:18 AS build

WORKDIR /app
COPY . .
RUN yarn install
RUN yarn build

FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]