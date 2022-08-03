FROM ubuntu:latest
COPY . /dotfiles
WORKDIR /dotfiles

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y git zsh curl sudo tzdata

RUN ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID breq \
    && useradd --uid $USER_UID --gid $USER_GID -m breq \
    && echo breq ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/breq \
    && chmod 0440 /etc/sudoers.d/breq

RUN chown -R breq:breq /dotfiles

USER breq

RUN chmod +x ./install.zsh
RUN ./install.zsh

CMD ["/bin/zsh"]
