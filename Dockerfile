FROM apache/airflow:slim-2.10.5-python3.9

# Instala os pacotes de sistema necessarios
USER root
RUN apt-get update && \
    apt-get install -y pkg-config libsystemd-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copiar os arquivos de requisitos
COPY requirements.txt /requirements.txt

# Atualizar pip e instalar dependências do Apache Airflow
USER airflow
RUN pip install --upgrade pip && \
    pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" -r /requirements.txt

# Instalar pacotes necessários para o ODBC Driver
USER root
RUN apt-get update && \
    apt-get install -y gnupg && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql17 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Alternar de volta para o usuário padrão do Airflow
USER airflow

RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" --user psycopg2-binary==2.9.9