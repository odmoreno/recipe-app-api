# Imagen base con Python 3.9 y Alpine 3.13 (ligera y eficiente)
FROM python:3.9-alpine3.13

# Información del mantenedor del Dockerfile
LABEL maintainer="odmorenoa@gmail.com"

# No buffer para que los logs de Python se vean inmediatamente
ENV PYTHONUNBUFFERED=1

# Copia el archivo de requerimientos al contenedor (usado temporalmente)
COPY ./requirements.txt /tmp/requirements.txt

COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Copia el directorio de la app al contenedor
COPY ./app /app

# Directorio de trabajo por defecto
WORKDIR /app

# Exponer el puerto para acceder al contenedor desde afuera
EXPOSE 8002

ARG DEV=false

# Instala las dependencias, limpia archivos temporales y crea un usuario seguro
RUN python -m venv /py && \
  /py/bin/pip install --upgrade pip && \
  /py/bin/pip install -r /tmp/requirements.txt && \
  if [ $DEV = "true" ]; \
  then /py/bin/pip install -r /tmp/requirements.dev.txt; \
  fi && \
  rm -rf /tmp && \
  adduser \
  --disabled-password \
  --no-create-home \
  django-user

# Agregar el entorno virtual al PATH global
ENV PATH="/py/bin:$PATH"

# Cambiar al usuario no-root para mayor seguridad
USER django-user