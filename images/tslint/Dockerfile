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
COPY images/tslint/package.json ${RUNNER_USER_HOME}/tslint_package.json
RUN cd ${RUNNER_USER_HOME} && \
    mkdir tslint && \
    mv tslint_package.json tslint/package.json && \
    cd tslint && \
    npm install --no-package-lock --ignore-scripts && \
    node_modules/.bin/tslint --version
ENV PATH ${RUNNER_USER_HOME}/tslint/node_modules/.bin:${PATH}
# See https://nodejs.org/api/cli.html#cli_node_path_path
ENV NODE_PATH ${RUNNER_USER_HOME}/tslint/node_modules:${NODE_PATH}

# By default, TSLint looks for a configuration file named tslint.json in the directory of the file being linted and, if not found, searches ancestor directories.
COPY images/tslint/default_tslint.json $RUNNER_USER_HOME/tslint.json

ENTRYPOINT ["runners", "--analyzer=tslint"]
