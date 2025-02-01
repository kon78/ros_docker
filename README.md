# Docker. Docker-Compose. Task 5.7. Practical work.

- How to run a containers?

## _First, build network._

```
docker network create foo
```

_Check network_

```
docker network ls
docker inspect foo
```

## _Second, run master._

```
docker run -it --rm --net foo --name master -p 11311 ros:noetic-ros-core roscore
``` 

> --net foo _network_
> --rm flag _The flag --rm is used when you need the container to be deleted after the task for it is complete._
> -p 11311 _port (can't start)_
> ros:noetic-ros-core _image ros_
> roscore _You must have a roscore running in order for ROS nodes to communicate._

## _Third, run talker._

```
docker run -it --rm -v /home/kostya/dock_data:/app/data -p 11311 --net foo --name talker --env ROS_HOSTNAME=talker --env ROS_MASTER_URI=http://master:11311 ros:noetic-ros-coreOS_HOSTNAME=talker --env ROS_MASTER_URI=http://master:11311 ros:noetic-ros-coreOS_HOSTNAME=talker --env ROS_MASTER_URI=http://master:11311 ros:noetic-ros-core
```

> -v /home/kostya/dock_data:/app/data _mounted folder /home/kostya/dock_data outter folder (your pc), /app/data inner folder (container)_
> --env environment _host name & net address_

## _Fourth, run listener._

```
docker run -it --rm --net foo -v /home/kostya/dock_data2:/app/data -p 11311 --name listener --env ROS_HOSTNAME=listener --env ROS_MASTER_URI=http://master:11311 ros:noetic-ros-core
```

Folders /app/data & /app/data contain an archive bt.tar with the package beginner_tutorials. script.bash unpacks data and places it in the system ros.

>
> /opt/ros/noetic/share/beginner_tutorials
>
> beginner_tutorials
>   +--CMakeLists.txt
>   +--include
>   +  |--beginner_tutorials
>   +--package.xml
>   +--scripts
>   +  |--listener.py
>   +  |--talker.py
>   +--src
>   +--talker_launch.launch
>

Python script talker.py publishes 

>
> │talker [INFO] [1738351776.813403]: hello world 1738351776.813119 967326726 
>

Python script listener.py

>
> │listener  | [INFO] [1738351964.316904]: /srandomI heard hello world 1738351964.3131528 527986727
>

- Scripts are executed manually (not docker compose).

## _container's talker & listener._

```
cd /app/data
./script.bash
roslaunch beginner_tutorials talker_launch.launch _talker_
roslaunch beginner_tutorials listener_launch.launch _listener_
```

- Use ctrl-C to stop app.

## Docker copmose. Multiply containers.

> Dockerfile.

```
# package
FROM ros:noetic-ros-core
# environment
ENV DEBIAN_FRONTEND=noninteractive
# install ros tutorials packages
RUN apt-get update && apt-get install -y \
    netcat \
		net-tools \
		nano \
		inetutils-ping \
		tar
#   ros-indigo-common-tutorials \
    && rm -rf /var/lib/apt/lists/

RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc
#		&& cd /app/data && ./script.bash
#    /app/data/.script.bash

CMD ["bash"]
```

> Base image noetic-ros-core
> launch package beginner_tutorials
> mounted folder /app/data/ contains script.bash to downloads the bt.tar /package beginner_tutorials/

- How run?

```
docker-compose -f docker-compose.yml up
```

> docker-compose.yml

```
version: '2'

networks:
  ros:
    driver: bridge

services:      
  master:
    build: .
    container_name: master
    networks:
      - ros
    command:
      - roscore
    restart: always

  talker:
    build: .
    container_name: talker
    environment:
      - "ROS_HOSTNAME=talker"
      - "ROS_MASTER_URI=http://master:11311"
    networks:
      - ros
    command: bash -c "
      cd /app/data
      && ./script.bash
      && ifconfig | grep inet
      && roslaunch beginner_tutorials talker_launch.launch"
    volumes:
      - /home/kostya/dock_data:/app/data
    restart: always

  listener:
    build: .
    container_name: listener
    environment:
      - "ROS_HOSTNAME=listener"
      - "ROS_MASTER_URI=http://master:11311"
    networks:
      - ros
    command: bash -c "
      cd /app/data
      && ./script.bash
      && ifconfig | grep inet      
      && roslaunch beginner_tutorials listener_launch.launch"
    volumes:
      - /home/kostya/dock_data2:/app/data
    restart: always
```

- How stop?

```
docker-compose  -f docker-compose.yml stop
docker-compose -f docker-compose.yml rm
```

> Network list. Out network rostutorials_ros /this example/

```
docker network ls
```

- Stop network

```
docker network prune /carefully!!!/
docker network rm rostutorials_ros /main command/
```
