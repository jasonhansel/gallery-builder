#!/bin/bash
mkdir /data

cd /opt/sortphotos/src/
echo Sorting photos...
python sortphotos.py -rcs --sort "%Y-%m" /pictures /data

echo Rotating photos...
find /data -type f -iname "*.jpg" -exec jhead -autorot {} \;

echo Running sigal...
sigal build -c /opt/sigal.conf.py --verbose /data /output

echo Deleting intermediate files...
rm -rf /data
