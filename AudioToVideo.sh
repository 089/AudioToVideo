# creates a youtube video with a still image
if [ -z "$1" ] && [ -z "$2" ] && [ -z "$3" ]; then
    echo Syntax:
    echo "AudioToVideo.sh /path/to/image.jpg /path/to/audio.mp3 \"Track Title\""
else
    # generate text image for video
    convert -gravity southeast -splice 20x20 -gravity northwest -splice 20x20 -font Helvetica -gravity Center -weight 700 -fill "#cc0000" -pointsize 40 pango:"<b>$3</b>" image-text.png
    # convert image to full hd for video
    convert -gravity Center -resize 1920x1080^ -extent 1920x1080 "$1" "$3"-1920x1080.png
    # merge transparent images for video
    composite -dissolve 100 -gravity North image-text.png "$3"-1920x1080.png -alpha Set "$3"-cover-1920x1080.png
    #convert image to square for SoundCloud and Insta
    convert -gravity Center -resize 1080x1080^ -extent 1080x1080 "$3"-cover-1920x1080.png "$3"-cover-1080x1080.png
    # genreate eq video
    ffmpeg -i "$2" -loop 1 -i "$3"-cover-1920x1080.png -filter_complex "[0:a]showwaves=s=1920x200:mode=cline:colors=0xff0000|0xCC0000:scale=sqrt[fg];[1:v]scale=1920:-1[bg];[bg][fg]overlay=shortest=1:900:format=auto,format=yuv420p[out]" -map "[out]" -map 0:a -pix_fmt yuv420p -c:v libx264 -preset medium -crf 18 -c:a copy -shortest "$3"-video.mkv

echo "$3"-1920x1080.png genrated
echo "$3"-cover-1920x1080.png generated
echo "$3"-cover-1080x1080.png generated
echo "$3"-video.mkv generated
fi
