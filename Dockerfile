FROM ubuntu:16.04

VOLUME /pictures
VOLUME /output

RUN apt-get update
RUN apt-get install -y python-dev python-pip zlib1g-dev libjpeg-dev libfreetype6-dev git ffmpeg exiftran jhead
RUN git clone https://github.com/andrewning/sortphotos.git

ADD * /
CMD ["/build.sh"]
