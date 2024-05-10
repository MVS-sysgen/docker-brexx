FROM debian:buster as builder

# Build tk4 docker with jcc and rdrprep installed
RUN apt update && apt install -yq unzip git make gcc
WORKDIR /
RUN git clone --depth 1 https://github.com/mvslovers/jcc.git
RUN git clone --depth 1 https://github.com/mvslovers/rdrprep.git
WORKDIR /rdrprep
RUN make && make install

# Deploy
FROM mainframed767/hercules:latest
LABEL version="0.1"
LABEL description="Docker container to build BREXX for various MVS"
USER root
RUN dpkg --add-architecture i386 && apt-get update && apt-get install --no-install-recommends --assume-yes wine wine32 make python3-pip zip unzip
WORKDIR /
COPY --from=builder /jcc/ /jcc/
COPY --from=builder /usr/local/bin/rdrprep /usr/local/bin/rdrprep
ADD tk4- /tk4-
ADD mvs-tk5 /mvs-tk5
ADD MVSCE /MVSCE
ADD loaded.sh /home/hercules/
ADD run.sh /
RUN chown 1000:1000 /MVSCE && pip install automvs sphinx sphinx_rtd_theme rst2pdf sphinx_markdown_builder 
ENV HERCULES_RC=scripts/ipl.rc
RUN echo "sh echo 'DONE' >> /home/hercules/done.txt" >> /tk4-/scripts/tk4-.rc
RUN echo "sh echo 'DONE' >> /home/hercules/done.txt" >> /mvs-tk5/scripts/tk5.rc
RUN echo "SHCMDOPT ENABLE DIAG8" >> /mvs-tk5/local_conf/01 && chmod +x /mvs-tk5/mvs