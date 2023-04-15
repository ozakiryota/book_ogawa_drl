#!/bin/bash

xhost +

image="book_ogawa_drl"
tag="latest"
exec_pwd=$(cd $(dirname $0); pwd)
home_dir="/home/user"

docker run \
	-it \
	--rm \
	-e local_uid=$(id -u $USER) \
	-e local_gid=$(id -g $USER) \
	-p 8000:8000 \
	--gpus all \
	-e "DISPLAY" \
	-v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	-v $exec_pwd/mount:$home_dir/Deep-Reinforcement-Learning-Book/tool \
	$image:$tag
