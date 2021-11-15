FROM nginx

WORKDIR /app

COPY conf/project.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

STOPSIGNAL SIGTERM

RUN apt update && apt install -y telnet nmap

CMD ["nginx", "-g", "daemon off;"]
