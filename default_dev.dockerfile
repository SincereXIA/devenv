# docker file for development
FROM ubuntu:latest
EXPOSE 22

# add user
RUN useradd -m -s /bin/bash -G sudo -u 1000 -U zhangjh

# set password (zhangjh:zhangjh) from env
ARG password=passwd
RUN echo "zhangjh:$password" | chpasswd

# set password (root:root) from env
RUN echo "root:$password" | chpasswd

# install openssh server
RUN apt-get update && apt install -y openssh-server

# base environment: vim, git, curl, wget, python3, pip3
RUN apt-get update && apt-get install -y \
    vim \
    git \
    curl \
    wget \
    python3 \
    python3-pip \
# c/c++ environment: gcc, g++, gdb, cmake
    gcc \
    g++ \
    gdb \
    cmake

RUN apt-get -f -y install
# install oh-my-zsh
RUN apt install -y zsh
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh && \
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    sed -i 's/^plugins=(/plugins=(zsh-autosuggestions zsh-syntax-highlighting z /' ~/.zshrc && \
    chsh -s /bin/zsh

# install golang
RUN wget https://dl.google.com/go/go1.15.2.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.15.2.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin
ENV GOPATH=/home/zhangjh/go
ENV PATH=$PATH:$GOPATH/bin

# start ssh server
CMD ["/usr/sbin/sshd"]
 


