# FROM tiangolo/uvicorn-gunicorn-fastapi:python3.8

# COPY . /app

# RUN pip install -r /app/requirements.txt

# CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

#new one
# Stage 1: Build Stage with Java and Dependencies
FROM python:3.8-slim-buster as build-stage

# Install necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-11-jdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# Install Python dependencies
COPY requirements.txt /app/requirements.txt
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY . /app

# Stage 2: Final Stage for FastAPI Application
FROM python:3.8-slim-buster

# Copy necessary files from the build stage
COPY --from=build-stage /usr/lib/jvm/java-11-openjdk-amd64 /usr/lib/jvm/java-11-openjdk-amd64
COPY --from=build-stage /usr/local/lib/python3.8/site-packages /usr/local/lib/python3.8/site-packages
COPY --from=build-stage /app /app

# Set JAVA_HOME environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# Set working directory
WORKDIR /app

# Set the command to run the FastAPI application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
