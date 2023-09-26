
FROM python:2.7
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
LABEL version="1.4"
ENV DockerHOME=/home/app/webapp
ENV DB_ENGINE=django.db.backends.postgresql_psycopg2  
RUN mkdir -p $DockerHOME  
WORKDIR $DockerHOME  
COPY . $DockerHOME  
RUN pip install -r requirements.txt  
RUN pip install psycopg2
CMD ./manage.py syncdb --noinput && ./manage.py migrate && ./manage.py runserver 0.0.0.0:8000
