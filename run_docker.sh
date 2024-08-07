xhost +

docker run --gpus all --rm -it --net=host -e DISPLAY=${DISPLAY} -v /tmp/argus_socket:/tmp/argus_socket -v /tmp/.X11-unix/:/tmp/.X11-unix -v $PWD:/workspace -w /workspace vila15 
