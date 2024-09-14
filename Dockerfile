# syntax=docker/dockerfile:1
FROM node:lts-slim AS build

# Change working directory
WORKDIR /app

COPY src ./src

RUN npm i -g nodemon


FROM node:lts-slim AS release

# Switch to non-root user uid=1000(node)
USER node

# Set node loglevel
ENV NPM_CONFIG_LOGLEVEL=warn

# Change working directory
WORKDIR /home/node

# Copy app directory from build stage
COPY --link --chown=1000 --from=build /app .
COPY --link --chown=1000 --from=build /usr/local/lib/node_modules/nodemon .npm-global/bin/nodemon

EXPOSE 3000

CMD ["node", "src/index.js"]
