FROM centos:7
RUN yum update -y
RUN yum install -y net-tools elinks
RUN yum install -y expat-devel prce-devel openssl-devel libnghttp2-devel
RUN yum groupinstall -y "Development tools"
RUN yum clean all
COPY ./src/ /root/
WORKDIR /root/httpd
RUN ./configure --prefix=/usr/local/apache2 --with-inclued-apr --with-mpm=event  --enable-ssl --with-pcre --enable-mods-shared=most --enable-mods-static='http mime headers version alias deflate expires proxy proxy_fcgi rewrite slotmem_shm'
#RUN ./configure --prefix=/usr/local/apache2 --with-inclued-apr --with-mpm=event  --enable-ssl --with-pcre --enable-mods-static=most
RUN make && make install
EXPOSE 80
#CMD /usr/local/apache2/bin/apachectl
ENTRYPOINT ["/usr/local/apache2/bin/apachectl"]
#ENTRYPOINT /usr/local/apache2/bin/apachectl
