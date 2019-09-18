# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_python:2.2.0

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

ARG LINT_TOOL_VERSION=3.7.7
RUN PYTHON2_VERSION=`pyenv versions --bare | grep '^2' --color=none` && \
    PYTHON3_VERSION=`pyenv versions --bare | grep '^3' --color=none` && \
    pyenv global $PYTHON2_VERSION && \
    pip install flake8==$LINT_TOOL_VERSION && \
    pyenv global $PYTHON3_VERSION && \
    pip install flake8==$LINT_TOOL_VERSION

USER root
COPY images/flake8/sider_config.ini $RUNNER_USER_HOME/.config/flake8
COPY images/flake8/ignored-config.ini $RUNNER_USER_HOME/.config/ignored-config.ini
RUN chown -R $RUNNER_USER $RUNNER_USER_HOME/.config
USER $RUNNER_USER

ENTRYPOINT ["runners", "--analyzer=flake8"]
