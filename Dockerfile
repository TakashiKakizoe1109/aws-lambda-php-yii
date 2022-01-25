FROM public.ecr.aws/lambda/provided as builder
ARG PHP_VERSION="8.0"
RUN yum clean all && \
    yum install -y \
        amazon-linux-extras \
        libcurl-devel

RUN amazon-linux-extras enable php${PHP_VERSION}
RUN yum install -y php-cli

RUN curl -sS https://getcomposer.org/installer | /usr/bin/php -- --install-dir=/opt/ --filename=composer
RUN mkdir /lambda-php-vendor && \
    cd /lambda-php-vendor && \
    /usr/bin/php /opt/composer require guzzlehttp/guzzle

COPY runtime/bootstrap /lambda-php-runtime/
RUN chmod 0755 /lambda-php-runtime/bootstrap

FROM public.ecr.aws/lambda/provided as runtime

ARG PHP_VERSION="8.0"
RUN yum clean all && \
    yum install -y amazon-linux-extras
RUN amazon-linux-extras enable php${PHP_VERSION}
RUN yum install -y php-cli
COPY --from=builder /lambda-php-runtime /var/runtime
COPY --from=builder /lambda-php-vendor/vendor /opt/vendor
COPY lambda/ /var/task/

CMD [ "app.handler" ]