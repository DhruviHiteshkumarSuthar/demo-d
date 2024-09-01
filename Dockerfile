FROM tiangolo/uvicorn-gunicorn-fastapi:python3.8

# Install Java
RUN apt-get update && apt-get install -y openjdk-8-jdk

COPY . /app

RUN pip install -r /app/requirements.txt

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]