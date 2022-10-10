FROM ruby:2.6.7-alpine

RUN apk update
RUN apk add git
RUN apk add build-base
RUN gem install bundler:1.15.4

ADD ./ /verify-metadata-generator/
WORKDIR /verify-metadata-generator/

RUN bundle
RUN bundle exec rake install
