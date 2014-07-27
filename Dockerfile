FROM mycrypt/debian
MAINTAINER Bai Xiaoyong lostitle@gmail.com

RUN apt-get update && \
		apt-get install -y build-essential checkinstall postgresql-client \
			git-core openssh-server mysql-server redis-server python2.7 python-docutils \
			libmysqlclient-dev libpq-dev zlib1g-dev libyaml-dev libssl-dev \
			libgdbm-dev libreadline-dev libncurses5-dev libffi-dev \
			libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev sudo curl && \
		apt-get clean

RUN echo "deb http://ftp.de.debian.org/debian/ wheezy-backports main contrib non-free" >> /etc/apt/sources.list && \
		apt-get update && \
		apt-get -t wheezy-backports install -y nginx

RUN mkdir /tmp/ruby && cd /tmp/ruby && \
		curl --progress ftp://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz | tar xz && \
		cd ruby-2.1.2 && \
		./configure && \
		make && \
		make install

RUN gem install --no-ri --no-rdoc bundler

ADD assets/setup/ /app/setup/
RUN chmod 755 /app/setup/install
RUN /app/setup/install

ADD assets/config/ /app/setup/config/
ADD assets/init /app/init
RUN chmod 755 /app/init

EXPOSE 22
EXPOSE 80
EXPOSE 443

VOLUME ["/home/git/data"]

ENTRYPOINT ["/app/init"]
CMD ["app:start"]
