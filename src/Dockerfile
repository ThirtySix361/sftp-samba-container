FROM debian:latest

RUN apt update && apt install -y openssh-server samba

ENV NAS_NAME=nas
ENV NAS_USER=user
ENV NAS_PASSWORD=pass

RUN mkdir -p /data/ && chmod 755 /data/

RUN sed -i 's/^Subsystem/#Subsystem/' /etc/ssh/sshd_config

COPY container/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22 445

ENTRYPOINT ["/entrypoint.sh"]
