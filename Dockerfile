FROM ubuntu:14.04
MAINTAINER Nathan Jones <nathan@ncjones.com>

# Install wkhtmltox
RUN apt-get update && apt-get install -y wget
RUN wget -O wkhtmltox.deb http://sourceforge.net/projects/wkhtmltopdf/files/0.12.1/wkhtmltox-0.12.1_linux-trusty-amd64.deb/download?use_mirror=superb-dca2
RUN apt-get update && apt-get install -y fontconfig libfontconfig1 libfreetype6 libjpeg-turbo8 libx11-6 libxext6 libxrender1
RUN dpkg -i wkhtmltox.deb

# Install additional fonts
RUN apt-get update && apt-get install -y fonts-wqy-zenhei fonts-thai-tlwg

# Install dependencies for running web service
RUN apt-get update && apt-get install -y python-pip
RUN pip install werkzeug gunicorn
RUN useradd gunicorn

ADD app.py /app.py
ADD config.py /config.py

EXPOSE 80
USER gunicorn
ENTRYPOINT ["gunicorn"]
CMD ["-c", "/config.py", "app:application"]

