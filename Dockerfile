FROM debian:stable-slim

RUN apt-get update

RUN apt-get install -y \
    sudo \
    openssl=3.0.11-1~deb12u2

RUN useradd -G root -m stuser && \
    echo 'stuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN mkdir -p /home/stuser/hostpwd && \
    touch /home/stuser/hostpwd/NA_FLAG_this_file_is_present_when_host_pwd_is_not_mounted  

COPY .build/ /usr/local/include/fz-security/
COPY default_omega_crypto.txt /usr/local/include/fz-security/
RUN chown -R stuser:stuser /usr/local/include/fz-security &&\
    ln -s /usr/local/include/fz-security/encrypter.sh /usr/local/bin/encrypt &&\
    ln -s /usr/local/include/fz-security/decrypter.sh /usr/local/bin/decrypt &&\
    ln -s /usr/local/include/fz-security/init.sh /usr/local/bin/init
    
USER stuser

WORKDIR /home/stuser/hostpwd
ENTRYPOINT [ "/bin/bash" ]