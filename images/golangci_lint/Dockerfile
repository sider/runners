# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE. IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE.
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM golangci/golangci-lint:v1.33.0 as golangci-lint

FROM sider/devon_rex_go:2.30.1

COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} --from=golangci-lint /usr/bin/golangci-lint ${RUNNER_USER_HOME}/bin/


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

COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/golangci_lint/sider_golangci.yml ${RUNNER_USER_HOME}/


# Copy the main source code
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} exe ${RUNNERS_DIR}/exe
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} lib ${RUNNERS_DIR}/lib

ENV PATH ${RUNNERS_DIR}/exe:${PATH}

# Run as non-root user
USER $RUNNER_USER
WORKDIR $RUNNER_USER_HOME

COPY images/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh", "runners", "--analyzer=golangci_lint"]
