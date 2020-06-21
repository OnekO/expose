FROM alpine

RUN apk --no-cache add \
    supervisor \
    nginx \
    php7 \
    git \
    unzip \
    yarn \
    wget \
    php7-mcrypt \
    php7-iconv \
    php7-pdo php7-pdo_mysql \
    php7-zip \
    php7-gd \
    php7-exif \
    php7-imagick \
    php7-redis \
    php7-apcu \
    php7-phar \
    php7-json \
    php7-curl \
    php7-ctype \
    php7-fileinfo \
    php7-xmlwriter \
    php7-sqlite3 \
    imagemagick-dev \
    tzdata \
    && rm  -rf /tmp/* /var/cache/apk/*

ENV TIMEZONE "Europe/Madrid"

RUN cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo "${TIMEZONE}" > /etc/timezone && \
    sed -i "s|;*date.timezone =.*|date.timezone = ${TIMEZONE}|i" /etc/php7/php.ini
RUN wget https://getcomposer.org/installer && php installer --install-dir=/usr/local/bin --filename=composer

ARG USER="default"
ENV USER=$USER
ENV HOME /home/$USER
RUN adduser -D $USER
USER $USER

RUN composer global require beyondcode/expose
ENV PATH "$PATH:/home/$USER/.composer/vendor/bin"

ENV DOMAIN="oneko.eu"

ARG PORT="3000"
ENV PORT=$PORT

ADD supervisord.conf /etc/
EXPOSE $PORT
ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
