FROM apache/airflow:2.10.5-python3.8

# Instala os pacotes de sistema necessarios
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    pkg-config \
    libsystemd-dev \
    libgl1 \
    libglib2.0-0 \
    libsm6 \
    libxrender1 \
    libxext6 \
    libgomp1 \
    libstdc++6 \
    # --- NOVAS DEPENDÊNCIAS PARA PLAYWRIGHT ---
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libpango-1.0-0 \
    libasound2 \
    # ------------------------------------------
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copiar os arquivos de requisitos
COPY requirements.txt /requirements.txt

# Atualizar pip e instalar dependências do Apache Airflow
USER airflow
RUN pip install --upgrade pip

# Instalar pacotes aos poucos para diminuir o tamanho das camadas
RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" pandas numpy

RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" requests requests-oauthlib requests-toolbelt requests-unixsocket selenium selenium-wire

RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" SQLAlchemy SQLAlchemy-JSONField SQLAlchemy-Utils

RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" pyodbc openpyxl bs4

RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" urllib3 jsonpatch jsonpointer jsonschema

RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" Jinja2 xlrd wget

RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" Unidecode regex tabula tabula-py tabulate

RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" lxml pretty-html-table icecream XlsxWriter

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

# Instalar pacotes necessários para compilar o DAWG
RUN apt-get update && \
    apt-get install -y build-essential libssl-dev libffi-dev python3-dev

# Alternar de volta para o usuário padrão do Airflow
USER airflow

# O ideal é sempre instalar novas bibliotecas no final, adicionando uma nova camada
RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" cloudscraper
RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" paddleocr
RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" paddlepaddle -f https://paddlepaddle.org.cn/whl/mkl/avx/stable.html
RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" chemdataextractor

# --- ADIÇÃO DO PLAYWRIGHT ---
RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" playwright
RUN playwright install chromium