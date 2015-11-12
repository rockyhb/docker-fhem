FROM centos:6

RUN yum -y update
RUN yum -y clean all

ENV FHEM_HOME /opt/fhem

# FHEM is ran with user `fhem`, uid = 1000
# If you bind mount a volume from host/volume from a data container, 
# ensure you use same uid
RUN useradd -d "$FHEM_HOME" -u 1000 -m -s /bin/bash fhem

# FHEM home directoy is a volume, so configuration and build history 
# can be persisted and survive image upgrades
VOLUME /opt/fhem

# Add Tini
ENV TINI_VERSION v0.8.3
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /bin/tini
RUN chmod +x /bin/tini

ADD http://fhem.de/fhem-5.6.tar.gz /usr/local/lib/fhem.tar.gz
RUN mkdir -p /usr/share/fhem/ref && cd /usr/share/fhem/ref && tar xvzf /usr/local/bin/fhem.tar.gz

# for main web interface:
EXPOSE 80

USER fhem

COPY fhem.sh /usr/local/bin/fhem.sh

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/fhem.sh"]

