FROM centos:7
RUN yum update -y
RUN yum install -y prce-devel openssl-devel libnghttp2-devel
COPY ./src/ /root/
WORKDIR /root/httpd
RUN pwd
RUN ./configure --prefix=/usr/local/apache2 --with-inclued-apr --with-mpm=event  --enable-ssl --with-pcre --enable-mods-static=most
#RUN make && make install
