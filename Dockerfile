FROM debian:bullseye

# upgrade debian packages
ENV DEBIAN_FRONTEND="noninteractive"
# fix "September 30th problem"
# https://github.com/nodesource/distributions/issues/1266#issuecomment-931597235
RUN apt update; apt install -y ca-certificates && \
    apt update;
RUN apt install apt-utils -y
RUN apt upgrade -y

# install the necessary things
RUN apt install -y \
    git \
    curl \
    zsh \
    neovim \
    python3-pip \
    neofetch \
    lolcat \
    cowsay \
    bat \
    exa \
    tmux \
    inetutils-ping \
;

# add /usr/games to the path so we can use lolcat and cowsay
ENV PATH=/usr/games:$PATH

# symlink batcat to bat
RUN ln -s /usr/bin/batcat /usr/bin/bat

# install ipmitool
RUN apt install ipmitool -y

# change working directory to root user's home directory
WORKDIR /root

# install zplug
# https://github.com/zplug/zplug#manually
ENV ZPLUG_HOME=/root/.zplug
RUN git clone https://github.com/zplug/zplug $ZPLUG_HOME

# install liquidprompt
RUN mkdir -p dev/git
RUN git clone https://github.com/nojhan/liquidprompt.git dev/git/liquidprompt
ENV LP_ENABLE_SSH_COLORS=1

# copy over zsh plugins and install
COPY .jeffreytse_zsh-vi-mode.tar.gz /root/.zplug/jeffreytse_zsh-vi-mode.tar.gz
RUN cd /root/.zplug && tar xzvf jeffreytse_zsh-vi-mode.tar.gz

# copy over .zshrc
COPY .zshrc .

# main working directory
WORKDIR /usr/src

# entrypoint
ENTRYPOINT ["/bin/zsh"]
