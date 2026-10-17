FROM nginx:latest
COPY ./conf/example.com.conf /etc/nginx/conf.d
RUN mkdir -p /var/www/vhosts/example.com/public_html
COPY ./src_dir /var/www/vhosts/example.com/public_html/
EXPOSE 80