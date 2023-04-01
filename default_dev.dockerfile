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
RUN apt-get install -y zsh && sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install zsh plugins
# zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
# zsh-syntax-highlighting
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
# add plugins to .zshrc
RUN sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc

# install golang
RUN wget https://dl.google.com/go/go1.15.2.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.15.2.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin
ENV GOPATH=/home/zhangjh/go
ENV PATH=$PATH:$GOPATH/bin

# install vscode-server
RUN wget https://update.code.visualstudio.com/latest/linux-deb-x64/stable -O vscode.deb && dpkg -i vscode.deb

# systemctl
RUN apt-get install -y systemd
RUN systemctl enable sshd


# start systemd
CMD ["/lib/systemd/systemd"]



