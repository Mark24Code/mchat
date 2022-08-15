FROM ruby:3.1-buster

RUN apt update -y
RUN apt install screen -y
RUN apt install vim -y
RUN apt install nano -y

RUN gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
RUN gem install bundler
RUN bundle config mirror.https://rubygems.org https://gems.ruby-china.com


# Install gems
RUN gem install rainbow
RUN gem install httparty
RUN gem install mchat

CMD ["bash"]