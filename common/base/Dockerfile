from openjdk:8

USER root

RUN apt-get update && apt-get install -y --no-install-recommends openssh-server vim net-tools curl netcat

WORKDIR /tmp
RUN wget https://downloads.lightbend.com/scala/2.12.5/scala-2.12.5.tgz
RUN tar xzf scala-2.12.5.tgz
RUN mv scala-2.12.5 /usr/share/scala
RUN ln -s /usr/share/scala/bin/* /usr/bin 
RUN rm scala-2.12.5.tgz

COPY ssh_config /etc/ssh/ssh_config
COPY sshd_config /etc/ssh/sshd_config

RUN service ssh start
CMD service ssh start && bash
