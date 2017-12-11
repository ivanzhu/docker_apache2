FROM centos:7
RUN yum update -y
RUN yum install -y net-tools elinks
RUN yum install -y expat-devel prce-devel openssl-devel
RUN yum groupinstall -y "Development tools"
RUN yum clean all
COPY ./src /root/src/
WORKDIR /root/src/nghttp2-1.28.0
RUN ./configure --prefix=/usr/local/nghttp2 --enable-lib-only
RUN make && make install
WORKDIR /root/src/httpd
RUN ./configure --prefix=/usr/local/apache2 \
    --with-inclued-apr \
    --with-mpm=event  \
    --enable-ssl \
    --with-pcre \
    --enable-http2 \
    --with-nghttp2=/usr/local/nghttp2 \
    --enable-mods-shared=most \
    --enable-mods-static='http http2 mime headers version alias deflate expires proxy proxy_fcgi rewrite slotmem_shm'
#RUN ./configure --prefix=/usr/local/apache2 --with-inclued-apr --with-mpm=event  --enable-ssl --with-pcre --enable-mods-static=most
RUN make && make install
EXPOSE 80
EXPOSE 443
# CMD ["/usr/local/apache2/bin/apachectl","start"]
# ENTRYPOINT ["/usr/local/apache2/bin/apachectl"]
ENTRYPOINT ["/usr/local/apache2/bin/apachectl"]
CMD ["-D", "FOREGROUND"]
