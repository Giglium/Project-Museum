FROM mysql:5.5

ENV MYSQL_ROOT_PASSWORD=root
ENV MYSQL_DATABASE=museum
ENV MYSQL_USER=museum
ENV MYSQL_PASSWORD=museum

COPY ./sql/*.sql /docker-entrypoint-initdb.d/

EXPOSE 3306
