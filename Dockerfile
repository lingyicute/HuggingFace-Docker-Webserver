FROM ubuntu:noble
RUN userdel -r ubuntu || true
RUN useradd -m -u 1000 lingyicute

# 安装核心组件
RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-mark hold snapd firefox fwupd \
    && apt-get install -y curl git openssh-client pbzip2 sudo wget util-linux tar gzip \
    && apt-get autoremove -y \
    && apt-get clean \
    && curl --proto '=https' --tlsv1.2 -sSfL https://get.static-web-server.net | sh \
    && chown -R lingyicute:lingyicute /home/lingyicute \
    && chmod 755 /home/lingyicute

USER lingyicute
WORKDIR /home/lingyicute
RUN git clone https://github.com/lingyicute/Me && rm -rf ./Me/.git
HEALTHCHECK CMD ["true"]
ENTRYPOINT ["/usr/local/bin/static-web-server", "--port", "7860", "--root", "/home/lingyicute/Me"]
