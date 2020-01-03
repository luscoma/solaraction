FROM ruby:latest 
RUN mkdir /usr/src/app 
COPY apikey.json /usr/src/app/ 
COPY app.rb /usr/src/app/ 
COPY Gemfile /usr/src/app/ 
COPY Gemfile.lock /usr/src/app/ 
COPY lib /usr/src/app/lib

WORKDIR /usr/src/app/ 
RUN bundle install --without=testing,development --deployment
CMD ["bundle", "exec", "app.rb"]
