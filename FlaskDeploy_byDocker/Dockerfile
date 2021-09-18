FROM debian:bullseye
RUN apt-get update

RUN apt-get install -y python3 python3-pip libpq-dev python3-dev


ENV PYTHONUNBUFFERED 1

RUN mkdir /code
WORKDIR /code
COPY requirements.txt /code/
RUN pip3 install -r requirements.txt
COPY . /code/

CMD python run.py
#CMD gunicorn --bind 0.0.0.0:5000 -w 3 run:app


RUN apt-get install -y nginx 
COPY conf /etc/nginx/conf.d/default.conf

RUN apt-get install -y postgresql 
ENV POSTGRES_USER admin
ENV POSTGRES_PASSWORD admin
ENV POSTGRES_DB market

EXPOSE 8080

