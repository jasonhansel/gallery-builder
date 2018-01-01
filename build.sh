#!/bin/bash

cd /opt/sortphotos/src/
echo Sorting photos...
python sortphotos.py -rcs --sort "%Y-%m" --rename "%Y-%M-%d-%H-%M" /pictures /output


echo Generating...
cd /output

# This is probably vulnerable to all sorts of injection attacks,
# but it's meant to be run on trusted input anyway.

echo "<!doctype html>" > ./index.html
echo "<link rel='stylesheet' href='/photos/styles.css'>" >> ./index.html
rm -rf ./**/index.html
for directory in ./19* ./20* ; do
	echo "<!doctype html>" > $directory/index.html
	echo "<link rel='stylesheet' href='/photos/styles.css'>" >> $directory/index.html
	for file in .. $directory/* ; do
		if [[ $file == *.thumb.jpg ]]; then
#			echo $file > /dev/stderr
			continue
		fi
		if [[ $file == *.jpg ]]; then
			jhead -autorot $file
		fi
		echo "<a class='card' href='/photos/$file'>"
		ffmpeg -n -v 16 -i $file -vf scale=w=150:h=150:force_original_aspect_ratio=increase \
			-vframes 1 -f image2 $file.thumb.jpg 2>>_error.txt
		if [ -f "$file.thumb.jpg" ] ; then
			echo "<img class='card-img' src='/photos/$file.thumb.jpg'>"
			if file -i $file | grep -q video  ; then
				echo '<div class="card-img-overlay"><i class="fa fa-play"></i></div>'
			fi
		else
			echo "<div class='card-body h5'>$file</div>"
		fi
		echo "</a>"
	done >> $directory/index.html
	echo "<a href='/photos/$directory'>$directory</a>" >> ./index.html
done


cd ..

cp styles.css ./output
