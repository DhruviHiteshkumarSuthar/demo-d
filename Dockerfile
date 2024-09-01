# FROM tiangolo/uvicorn-gunicorn-fastapi:python3.8

# COPY . /app

# RUN pip install -r /app/requirements.txt

# CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

#new one
# Use a lightweight Python base image
FROM python:3.8-slim

# Install Amazon Corretto JDK 11
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget curl && \
    wget -O- https://apt.corretto.aws/corretto.key | apt-key add - && \
    add-apt-repository 'deb https://apt.corretto.aws stable main' && \
    apt-get update && \
    apt-get install -y java-11-amazon-corretto-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto
ENV PATH=$JAVA_HOME/bin:$PATH

# Install necessary Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY . /app
WORKDIR /app

# Expose the FastAPI port
EXPOSE 8000

# Run the FastAPI application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]