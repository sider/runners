# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_npm:2.3.0

ARG RUNNERS_DIR=${RUNNER_USER_HOME}/runners
COPY Gemfile* Rakefile ${RUNNERS_DIR}/
COPY bin ${RUNNERS_DIR}/bin
COPY lib ${RUNNERS_DIR}/lib
USER root
RUN chown -R ${RUNNER_USER}: ${RUNNERS_DIR}
USER $RUNNER_USER

RUN cd ${RUNNERS_DIR} && \
    bundle config --global jobs 4 && \
    bundle config --global retry 3 && \
    bundle config && \
    bundle install --without='development test'
ENV PATH ${RUNNERS_DIR}/bin:${PATH}

# Install the default version
COPY images/stylelint/package.json ${RUNNER_USER_HOME}/stylelint_package.json
RUN cd ${RUNNER_USER_HOME} && \
    mkdir stylelint && \
    mv stylelint_package.json stylelint/package.json && \
    cd stylelint && \
    npm config set ignore-scripts true && \
    npm config set progress false && \
    npm config set package-lock false && \
    npm install && \
    node_modules/.bin/stylelint --version
ENV PATH ${RUNNER_USER_HOME}/stylelint/node_modules/.bin:${PATH}
# See https://nodejs.org/api/cli.html#cli_node_path_path
ENV NODE_PATH ${RUNNER_USER_HOME}/stylelint/node_modules:${NODE_PATH}

# NOTE: Install the older version to run `stylelint-config-recommended` with stylelint v8.
RUN cd ${RUNNER_USER_HOME} && \
    mkdir stylelint-config-recommended.old && \
    cd stylelint-config-recommended.old && \
    npm install stylelint-config-recommended@2
COPY images/stylelint/sider_recommended_config.old.yaml ${RUNNER_USER_HOME}/

COPY images/stylelint/sider_recommended_config.yaml images/stylelint/sider_recommended_stylelintignore ${RUNNER_USER_HOME}/

USER root
RUN chown -R ${RUNNER_USER}: ${RUNNER_USER_HOME}
USER $RUNNER_USER

ENTRYPOINT ["runners", "--analyzer=stylelint"]
