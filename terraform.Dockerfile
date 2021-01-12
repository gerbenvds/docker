FROM alpine:latest

LABEL maintainer="SRE-Team <sre@takeaway.com>"

RUN apk update && \
  set -ex && \
  apk add ca-certificates && update-ca-certificates && \
  apk add --no-cache --update \
  bash \
  curl \
  findutils \
  git \
  jq \
  tzdata \
  unzip \
  sed \
  openssh-client \
  openssl \
  openssl-dev \
  python3-dev \
  mysql-client

RUN apk --update add --virtual .build-dependencies \
  build-base \
  libffi-dev \
  libxml2-dev \
  libxslt-dev \
  py3-pip

RUN pip3 install --no-cache --upgrade --ignore-installed six \
  awscli \
  awsebcli \
  boto3 \
  requests \
  terraform-compliance

RUN apk del --purge .build-dependencies \
  && rm -rf /var/cache/apk/* /tmp/*

RUN git clone https://github.com/tfutils/tfenv.git ~/.tfenv && \
  ln -s ~/.tfenv/bin/* /usr/local/bin && \
  tfenv install 0.12.29 && \
  tfenv install 0.13.4 && \
  echo '0.12.29' > ~/.tfenv/version

COPY --from=alpine/terragrunt:0.13.5 /usr/local/bin/terragrunt /usr/local/bin/terragrunt
COPY --from=wata727/tflint:0.15.4 /usr/local/bin/tflint /usr/local/bin/tflint

ENTRYPOINT []
CMD ["/bin/bash"]
