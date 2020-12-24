# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE. IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE.
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_npm:2.29.0


ARG RUNNERS_DIR=${RUNNER_USER_HOME}/runners

# Install required gems first (due to slow download)
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} Gemfile Gemfile.lock runners.gemspec analyzers.yml ${RUNNERS_DIR}/
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} lib/runners/version.rb ${RUNNERS_DIR}/lib/runners/

RUN cd ${RUNNERS_DIR} && \
    bundle config set --global jobs 4 && \
    bundle config set --global retry 3 && \
    bundle config && \
    BUNDLE_WITHOUT=development:test bundle install && \
    bundle list

# Install the default version
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/stylelint/package.json ${RUNNER_USER_HOME}/stylelint_package.json
RUN cd ${RUNNER_USER_HOME} && \
    mkdir stylelint && \
    mv stylelint_package.json stylelint/package.json && \
    cd stylelint && \
    npm config set ignore-scripts true && \
    npm config set progress false && \
    npm config set package-lock false && \
    npm install && \
    npm ls --depth 0 # Check required peer dependencies
ENV PATH ${RUNNER_USER_HOME}/stylelint/node_modules/.bin:${PATH}
# See https://nodejs.org/api/cli.html#cli_node_path_path
ENV NODE_PATH ${RUNNER_USER_HOME}/stylelint/node_modules:${NODE_PATH}

# NOTE: Install the older version to run `stylelint-config-recommended` with stylelint v8.
RUN cd ${RUNNER_USER_HOME} && \
    mkdir stylelint-config-recommended.old && \
    cd stylelint-config-recommended.old && \
    npm install stylelint-config-recommended@2

COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} \
     images/stylelint/sider_recommended_config.old.yaml \
     images/stylelint/sider_recommended_config.yaml \
     images/stylelint/sider_recommended_stylelintignore \
     ${RUNNER_USER_HOME}/


# Copy the main source code
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} exe ${RUNNERS_DIR}/exe
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} lib ${RUNNERS_DIR}/lib

ENV PATH ${RUNNERS_DIR}/exe:${PATH}

# Run as non-root user
USER $RUNNER_USER
WORKDIR $RUNNER_USER_HOME

COPY images/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh", "runners", "--analyzer=stylelint"]
