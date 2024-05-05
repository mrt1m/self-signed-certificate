FROM nginx:alpine3.18-slim

COPY ./default.conf.template /etc/nginx/templates/server.conf.template
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./public /var/www/public
COPY ./ssl /ssl

CMD ["nginx", "-g", "daemon off;"]
