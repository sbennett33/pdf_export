FROM hexpm/elixir:1.13.4-erlang-23.3.4.9-alpine-3.14.2 AS builder

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64
RUN chmod +x /usr/local/bin/dumb-init

WORKDIR /app

ENV MIX_ENV="prod"

RUN mix local.hex --force
RUN mix local.rebar --force

COPY mix.* ./

RUN mix deps.get
RUN mix deps.compile

COPY lib lib
COPY rel rel

RUN mix compile

RUN mix release

FROM zenika/alpine-chrome:latest

USER root

WORKDIR "/app"
RUN chown nobody /app

# set runner ENV
ENV MIX_ENV="prod"

COPY --from=builder --chown=nobody:root /usr/local/bin/dumb-init /usr/local/bin/dumb-init
COPY --from=builder --chown=nobody:root /app/_build/prod/rel/pdf_export ./

USER nobody

ENTRYPOINT ["dumb-init", "--"]

CMD ["/app/bin/pdf_export", "start"]
