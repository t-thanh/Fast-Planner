FROM turlucode/ros-melodic:cuda10.1-cudnn7

MAINTAINER t-thanh <tien.thanh@eu4m.eu>

RUN apt-get update && apt-get install -y sudo wget
RUN adduser --disabled-password --gecos '' docker
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN export uid=1000 gid=1000
RUN mkdir -p /home/docker
RUN echo "docker:x:${uid}:${gid}:docker,,,:/home/docker:/bin/bash" >> /etc/passwd
RUN echo "docker:x:${uid}:" >> /etc/group
#RUN echo "docker ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN chmod 0440 /etc/sudoers
RUN chown ${uid}:${gid} -R /home/docker

USER docker
WORKDIR /home/docker
RUN /bin/bash -c 'sudo apt-get update && sudo apt-get install -y libarmadillo-dev ros-melodic-nlopt libdw-dev git && \
	cd /home/docker && \
	mkdir -p Fast-Planner/catkin_ws/src && source /opt/ros/melodic/setup.bash && cd Fast-Planner/catkin_ws && catkin_make && \
	source devel/setup.bash && cd src && git clone https://github.com/t-thanh/Fast-Planner && \
	cd .. && catkin_make'
RUN echo "source /home/docker/Fast-Planner/catkin_ws/devel/setup.bash" > ~/.bashrc
# Launch terminator
CMD ["terminator"]
