# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_python:2.2.2

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
COPY images/flake8/Pipfile ${RUNNER_USER_HOME}/flake8_Pipfile
RUN cd ${RUNNER_USER_HOME} && \
    mkdir flake8 && \
    mv flake8_Pipfile flake8/Pipfile && \
    cd flake8 && \
    for version in "${PYTHON2_VERSION}" "${PYTHON3_VERSION}"; do \
      pyenv global ${version} && \
      pipenv install --system --skip-lock && \
      pyenv rehash && \
      echo "In '$(python --version 2>&1)', the version of the analyzer 'flake8' is ..." && \
      flake8 --version && \
      : ; \
    done && \
    echo "The default Python runtime version is '$(python --version)'"

COPY images/flake8/sider_config.ini $RUNNER_USER_HOME/.config/flake8
COPY images/flake8/ignored-config.ini $RUNNER_USER_HOME/.config/ignored-config.ini

USER root
RUN chown -R ${RUNNER_USER}: ${RUNNER_USER_HOME}
USER $RUNNER_USER

ENTRYPOINT ["runners", "--analyzer=flake8"]
