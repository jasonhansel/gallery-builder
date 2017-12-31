FROM nginx:stable
VOLUME /pictures
VOLUME /output

WORKDIR /opt
RUN apt-get update
RUN apt-get install -y python-dev python-pip zlib1g-dev libjpeg-dev libfreetype6-dev git ffmpeg exiftran jhead
RUN pip install sigal
RUN git clone https://github.com/andrewning/sortphotos.git

ADD build.sh ./
ADD sigal.conf.py ./

ENV LANG C.UTF-8
CMD ["/opt/build.sh"]
