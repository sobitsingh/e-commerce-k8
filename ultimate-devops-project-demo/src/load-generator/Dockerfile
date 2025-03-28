FROM python:3.12-slim-bookworm as build

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
ENTRYPOINT [ "python","locustfile.py" ]