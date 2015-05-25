FROM rancher/docker-dind-base:v0.4.1
MAINTAINER James Harris <james@rancher.com> @wizardofmath

RUN wget http://stedolan.github.io/jq/download/linux64/jq
RUN wget https://github.com/github/hub/releases/download/v2.2.0-rc1/hub-linux-amd64-2.2.0-rc1.tar.gz
RUN tar xzf hub-linux-amd64-2.2.0-rc1.tar.gz
RUN rm -f hub-linux-amd64-2.2.0-rc1.tar.gz
RUN mkdir /source
RUN mkdir /source/bin
RUN mv /hub_2.2.0-rc1_linux_amd64/hub /source/bin/hub
RUN rm -rf /hub_2.2.0-rc1_linux_amd64
RUN mv /jq /source/bin/jq
RUN chmod u+rwx /source/bin/jq
ADD ./ /source/

RUN . /source/start.sh && /source/retrieveTheRanch.sh

CMD [ "/bin/bash" ]