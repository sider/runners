# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE. IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE.
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_npm:master


ARG RUNNERS_DIR=${RUNNER_USER_HOME}/runners

# Install required gems first (due to slow download)
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} Gemfile* analyzers.yml ${RUNNERS_DIR}/
RUN cd ${RUNNERS_DIR} && \
    bundle config set --global jobs 4 && \
    bundle config set --global retry 3 && \
    bundle config && \
    BUNDLE_WITHOUT=development:test bundle install && \
    bundle list

# Install the default version
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/tslint/package.json ${RUNNER_USER_HOME}/tslint_package.json
RUN cd ${RUNNER_USER_HOME} && \
    mkdir tslint && \
    mv tslint_package.json tslint/package.json && \
    cd tslint && \
    npm config set ignore-scripts true && \
    npm config set progress false && \
    npm config set package-lock false && \
    npm install
ENV PATH ${RUNNER_USER_HOME}/tslint/node_modules/.bin:${PATH}
# See https://nodejs.org/api/cli.html#cli_node_path_path
ENV NODE_PATH ${RUNNER_USER_HOME}/tslint/node_modules:${NODE_PATH}

# By default, TSLint looks for a configuration file named tslint.json in the directory of the file being linted and, if not found, searches ancestor directories.
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/tslint/default_tslint.json ${RUNNER_USER_HOME}/tslint.json


# Copy the main source code
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} bin ${RUNNERS_DIR}/bin
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} lib ${RUNNERS_DIR}/lib

ENV PATH ${RUNNERS_DIR}/bin:${PATH}

# Run as non-root user
USER $RUNNER_USER
WORKDIR $RUNNER_USER_HOME

ENTRYPOINT ["/usr/bin/timeout", "--signal=SIGUSR2", "--kill-after=10s", "30m", "runners", "--analyzer=tslint"]
