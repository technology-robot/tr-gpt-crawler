# Specify the base Docker image. You can read more about
# the available images at https://crawlee.dev/docs/guides/docker-images
# You can also use any other image from Docker Hub.
FROM apify/actor-node-playwright-chrome:20 AS builder

# Copy just package.json and package-lock.json
# to speed up the build using Docker layer cache.
COPY --chown=myuser package*.json ./

# Install all dependencies. Don't audit to speed up the installation.
RUN npm install --include=dev --audit=false

# Next, copy the source files using the user set
# in the base image.
COPY --chown=myuser . ./

# Install all dependencies and build the project.
# Don't audit to speed up the installation.
RUN npm run build

# Create final image
FROM apify/actor-node-playwright-chrome:20

# Allow statements and log messages to immediately appear in the Cloud Run logs
ENV PYTHONUNBUFFERED 1

# Copy only built JS files from builder image
COPY --from=builder --chown=myuser /home/myuser/dist ./dist

# Copy just package.json and package-lock.json
# to speed up the build using Docker layer cache.
COPY --chown=myuser package*.json ./

# Install NPM packages, skip optional and development dependencies to
# keep the image small. Avoid logging too much and print the dependency
# tree for debugging
RUN npm --quiet set progress=false \
    && npm install --omit=dev --omit=optional \
    && echo "Installed NPM packages:" \
    && (npm list --omit=dev --all || true) \
    && echo "Node.js version:" \
    && node --version \
    && echo "NPM version:" \
    && npm --version

# Revert back to root before myuser
USER root

RUN --mount=type=cache,target=/var/cache/apt apt-get update && apt-get install --fix-missing -y python3 python3-pip

USER myuser

COPY --chown=myuser requirements.txt ./

RUN pip3 install -r requirements.txt

# Next, copy the remaining files and directories with the source code.
# Since we do this after NPM install, quick build will be really fast
# for most source file changes.
COPY --chown=myuser . ./

RUN chmod +x ./crawl.sh

ENTRYPOINT [ "/bin/bash", "-c" ]

ARG CONF_JSON="jsons/rewe-2023-12-11.json"
ARG OUTPUT_CSV_GCS="gs://tr-aisha/product-recommendation/sample-rewe/output.csv"

ENV CONF_JSON=$CONF_JSON
ENV OUTPUT_CSV_GCS=$OUTPUT_CSV_GCS

CMD [ "./crawl.sh $CONF_JSON $OUTPUT_CSV_GCS" ]
