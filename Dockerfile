# Source Image
 FROM ubuntu:latest

  # Set noninterative mode
 ENV DEBIAN_FRONTEND noninteractive

  # apt update and install global requirements
 RUN apt-get clean all && \
     apt-get update && \
     apt-get upgrade -y && \
     apt-get install -y  \
         autoconf \
         build-essential \
         cmake \
         git \
         libbz2-dev \
         libcurl4-openssl-dev \
         libssl-dev \
         zlib1g-dev \
         liblzma-dev

  # apt clean and remove cached source lists
 RUN apt-get clean && \
     rm -rf /var/lib/apt/lists/*

 RUN git clone https://github.com/samtools/htslib.git
 RUN cd htslib && \
     autoheader && \
     autoconf && \
     ./configure --prefix=/usr/local/ && \
     make && \
     make install
  
# Install popscle
 RUN git clone https://github.com/statgen/popscle.git
 RUN cd popscle && \
     mkdir build && \
     cd build && \
     cmake .. && \
     make
 RUN cp /popscle/bin/popscle /usr/local/bin

  # Define default command
 #CMD ["popscle"]
 COPY ./entrypoint.sh /
 RUN chmod 755 /entrypoint.sh
 ENTRYPOINT ["/entrypoint.sh"]
