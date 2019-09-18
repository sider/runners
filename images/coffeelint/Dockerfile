# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_npm:2.2.0

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
ENV BUNDLE_GEMFILE ${RUNNERS_DIR}/Gemfile
ENV PATH ${RUNNERS_DIR}/bin:${PATH}

# Install the default version
COPY images/coffeelint/package.json ${RUNNER_USER_HOME}/coffeelint_package.json
RUN cd ${RUNNER_USER_HOME} && \
    mkdir coffeelint && \
    mv coffeelint_package.json coffeelint/package.json && \
    cd coffeelint && \
    npm install --no-package-lock --ignore-scripts && \
    node_modules/.bin/coffeelint --version
ENV PATH ${RUNNER_USER_HOME}/coffeelint/node_modules/.bin:${PATH}
# See https://nodejs.org/api/cli.html#cli_node_path_path
ENV NODE_PATH ${RUNNER_USER_HOME}/coffeelint/node_modules:${NODE_PATH}

ENTRYPOINT ["runners", "--analyzer=coffeelint"]
