FROM python:3.11.13

WORKDIR /app

COPY requirements.txt .
COPY test_requirements.txt .

RUN pip install -r requirements.txt
RUN pip install -r test_requirements.txt

COPY . .

CMD python src/server.py
