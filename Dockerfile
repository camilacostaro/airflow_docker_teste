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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copiar os arquivos de requisitos
COPY requirements.txt /requirements.txt

# Atualizar pip e instalar dependências do Apache Airflow
USER airflow
RUN pip install --upgrade pip

# Instalar pacotes aos poucos para diminuir o tamanho das camadas

RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" pandas==2.1.4 numpy==1.26.4

RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" requests==2.31.0 requests-oauthlib==1.4.0 requests-toolbelt==1.0.0 requests-unixsocket==0.3.0 selenium==4.29.0 selenium-wire==5.1.0

RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" SQLAlchemy==1.4.52 SQLAlchemy-JSONField==1.0.2 SQLAlchemy-Utils==0.41.1 pyodbc==5.1.0

RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" splinter==0.21.0 asttokens==3.0.0 tqdm==4.67.1 openpyxl==3.1.5 bs4==0.0.2

RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" pikepdf==9.5.2 pdfminer.six==20221105 pdfkit==1.0.0 pdfplumber==0.8.0 PyPDF2==3.0.1 PyMuPDF==1.25.3

RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" urllib3==2.0.7 jsonpatch==1.33 jsonpointer==3.0.0 jsonschema==4.21.1

RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" elasticsearch==8.12.1 elasticsearch-dsl==8.17.1 Jinja2==3.1.3 xlrd==2.0.1 textract==1.5.0 wget==3.2

RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" Unidecode==1.3.8 regex==2024.11.6 tabula==1.0.5 tabula-py==2.10.0 tabulate==0.9.0

RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" lxml==5.1.0 pretty-html-table==0.9.16 icecream==2.1.4 XlsxWriter==3.2.2

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
RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" cloudscraper==1.2.71
RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" fpdf==1.7.2
RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" camelot-py[cv]==1.0.0
RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" paddleocr==2.10.0
RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" paddlepaddle==3.0.0 -f https://paddlepaddle.org.cn/whl/mkl/avx/stable.html
RUN pip install --no-cache-dir "apache-airflow==${AIRFLOW_VERSION}" chemdataextractor