#!/bin/bash

cd /sortphotos/src/
echo Sorting photos...
python sortphotos.py -rcs --sort "%Y-%m" --rename "%Y-%m-%d-%H-%M" /pictures /output


echo Generating...
cp -f /styles.css /output
cd /output

# This is probably vulnerable to all sorts of injection attacks,
# but it's meant to be run on trusted input anyway.

#echo "<!doctype html>" > ./index.html
#echo "<link rel='stylesheet' href='/photos/styles.css'>" >> ./index.html
rm -rf ./**/index.html
for directory in . 19* 20* ; do
	echo "Processing $directory..."
	echo "<!doctype html>" > $directory/index.html
	echo "<title>$(basename $directory)</title>" >> $directory/index.html
	echo "<link rel='stylesheet' href='/photos/styles.css'>" >> $directory/index.html
	for file in $directory/.. $directory/* ; do
		if [[ $file == *.thumb.jpg ]]; then
			continue
		fi
		if [[ $file == *.html ]]; then
			continue
		fi
		if [[ $file == *.jpg ]]; then
			jhead -autorot $file >/dev/null
		fi
		if [ ! -d "$file" ] && [ ! -f "$file.thumb.jpg" ] ; then
			ffmpeg -t 0.2 -i $file -vframes 1 -vf scale=w=150:h=150:force_original_aspect_ratio=increase -sws_flags neighbor \
				-f image2 $file.thumb.jpg >/dev/null
		fi
		echo "<a class='card text-center' href='/photos/$file'>"
		if [ -f "$file.thumb.jpg" ] ; then
			echo "<img class='card-img' src='/photos/$file.thumb.jpg'>"
			if [[ "$(file -bi $file)" == video* ]] ; then
				echo '<div class="card-img-overlay text-center"><i class="fa fa-play fa-4x text-white"></i></div>'
			fi
		else
			echo "<div class='card-body h5'>$file</div>"
		fi
		echo "</a>"
	done 2>>/output/_error.txt >>$directory/index.html
#	echo "<a href='/photos/$directory'>$directory</a>" >> ./index.html
done


cd ..

