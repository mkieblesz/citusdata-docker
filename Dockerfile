FROM citusdata/citus:8.3.2

ENV DEBIAN_FRONTEND "noninteractive"

# install requirements
RUN apt-get update && \
    apt-get install -y apt-utils wget curl ca-certificates build-essential unzip postgresql-server-dev-11

# install Partman
RUN wget https://github.com/pgpartman/pg_partman/archive/v4.2.2.zip -O 4.2.2.zip && \
    unzip 4.2.2.zip && \
    cd /pg_partman-4.2.2 && pwd && make install && \
    echo "shared_preload_libraries = 'pg_partman_bgw'" >> $PGDATA/postgresql.conf

# install postgresql-hll
RUN wget https://github.com/citusdata/postgresql-hll/archive/v2.12.zip -O 2.12.zip && \
    unzip 2.12.zip && \
    cd /postgresql-hll-2.12 && pwd && make install

# add scripts to run after initdb
COPY docker-entrypoint-initdb.d/* /docker-entrypoint-initdb.d/

# cleanup
# RUN apt-get purge -y --auto-remove curl wget && \
#     rm -rf /var/lib/apt/lists/*
