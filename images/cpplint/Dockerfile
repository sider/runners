# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE. IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE.
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_python:2.26.0


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
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/cpplint/Pipfile ${RUNNER_USER_HOME}/cpplint_Pipfile
RUN cd ${RUNNER_USER_HOME} && \
    mkdir cpplint && \
    mv cpplint_Pipfile cpplint/Pipfile && \
    cd cpplint && \
    for version in "${PYTHON2_VERSION}" "${PYTHON3_VERSION}"; do \
      pyenv global ${version} && \
      pipenv install --system --skip-lock && \
      pyenv rehash && \
      echo "In '$(python --version 2>&1)', the version of the analyzer 'cpplint' is ..." && \
      cpplint --version && \
      : ; \
    done && \
    echo "The default Python runtime version is '$(python --version)'"

# Copy the main source code
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} bin ${RUNNERS_DIR}/bin
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} lib ${RUNNERS_DIR}/lib

ENV PATH ${RUNNERS_DIR}/bin:${PATH}

# Run as non-root user
USER $RUNNER_USER
WORKDIR $RUNNER_USER_HOME

COPY images/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh", "runners", "--analyzer=cpplint"]
