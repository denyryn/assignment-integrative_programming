ARG BASE_IMAGE=python:3.11-slim
FROM ${BASE_IMAGE}

ARG APP_PORT=8000

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE ${APP_PORT}

ENV APP_PORT=${APP_PORT}

CMD flask --app main run --host=0.0.0.0 --port=${APP_PORT}
