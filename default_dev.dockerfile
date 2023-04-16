# docker file for development
FROM ubuntu:latest
EXPOSE 22

# set password (zhangjh:zhangjh) from env
ARG password=passwd

# set password (root:root) from env
RUN echo "root:$password" | chpasswd

# change apt source
RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak
RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
RUN sed -i 's/security.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
RUN sed -i 's/ports.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list

# install openssh server
RUN apt-get update && apt install -y openssh-server \
	screen sudo

RUN mkdir -p /var/run/sshd && mkdir -p /run/sshd

# base environment: vim, git, curl, wget, python3, pip3
RUN apt-get update && apt-get install -y \
    vim \
    git \
    curl \
    wget \
    python3 \
    python3-pip \
	python3-venv \
# c/c++ environment: gcc, g++, gdb, cmake
    gcc \
    g++ \
    gdb \
    cmake

RUN apt-get -f -y install
# install oh-my-zsh
RUN apt install -y zsh

# install golang
RUN wget https://dl.google.com/go/go1.15.2.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.15.2.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin
ENV GOPATH=/home/zhangjh/go
ENV PATH=$PATH:$GOPATH/bin

# add user
RUN useradd -m -s /bin/zsh -G sudo -u 1000 -U zhangjh
RUN echo "zhangjh:$password" | chpasswd
RUN chsh -s /bin/zsh zhangjh

RUN sudo -u zhangjh bash -c \
    "git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh && \
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
    sed -i 's/^plugins=(/plugins=(zsh-autosuggestions zsh-syntax-highlighting z /' ~/.zshrc"


# start ssh server
CMD ["/usr/sbin/sshd", "-D"]



