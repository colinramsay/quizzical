FROM elixir:1.12.2

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
COPY . $APP_HOME

RUN mix local.hex --force \
  && apt-get update \
  && curl -sL https://deb.nodesource.com/setup_12.x | bash \
  && apt-get install -y apt-utils \
  && apt-get install -y nodejs \
  && apt-get install -y build-essential \
  && apt-get install -y inotify-tools \
  && mix local.rebar --force


RUN mix deps.get
RUN mix deps.compile

EXPOSE 4000

CMD ["mix", "phx.server"]