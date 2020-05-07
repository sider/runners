# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE. IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE.
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_go:master

ARG LINT_TOOL_VERSION="2.0.11"

USER root
RUN curl -sSL --compressed https://github.com/alecthomas/gometalinter/releases/download/v${LINT_TOOL_VERSION}/gometalinter-${LINT_TOOL_VERSION}-linux-amd64.tar.gz | \
    tar -xzC . && \
    cd gometalinter-${LINT_TOOL_VERSION}-linux-amd64/ && \
    rm COPYING README.md && \
    mv * /usr/local/bin/ && \
    cd .. && \
    rm -r gometalinter-${LINT_TOOL_VERSION}-linux-amd64/
USER $RUNNER_USER


ARG RUNNERS_DIR=${RUNNER_USER_HOME}/runners

# Install required gems first (due to slow download)
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} Gemfile* analyzers.yml ${RUNNERS_DIR}/
RUN cd ${RUNNERS_DIR} && \
    bundle config set --global jobs 4 && \
    bundle config set --global retry 3 && \
    bundle config && \
    BUNDLE_WITHOUT=development:test bundle install && \
    bundle list

COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/gometalinter/gometalinter.json ${RUNNER_USER_HOME}/


# Copy the main source code
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} bin ${RUNNERS_DIR}/bin
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} lib ${RUNNERS_DIR}/lib

ENV PATH ${RUNNERS_DIR}/bin:${PATH}

# Run as non-root user
USER $RUNNER_USER
WORKDIR $RUNNER_USER_HOME

ENTRYPOINT ["/usr/bin/timeout", "--signal=SIGUSR2", "--kill-after=10s", "30m", "runners", "--analyzer=gometalinter"]
