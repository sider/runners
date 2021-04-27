# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE. IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE.
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_java:master


ENV RUNNERS_DEPS_DIR ${RUNNER_USER_HOME}/dependencies
ARG RUNNERS_DIR=${RUNNER_USER_HOME}/runners

# Install required gems first (due to slow download)
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} Gemfile Gemfile.lock runners.gemspec analyzers.yml ${RUNNERS_DIR}/
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} lib/runners/version.rb ${RUNNERS_DIR}/lib/runners/

RUN cd "${RUNNERS_DIR}" && \
    bundle config set --global jobs 4 && \
    bundle config set --global retry 3 && \
    bundle config && \
    BUNDLE_WITHOUT=development bundle install && \
    bundle list && \
    echo 'Checking if the Bundler version is expected...' && \
    lockfile_bundler_version=$(bundle exec ruby -e 'puts Bundler.locked_gems.bundler_version') && \
    bundle version | grep "Bundler version ${lockfile_bundler_version}"

ARG JAVASEE_VERSION=0.2.0

RUN mkdir /tmp/work && \
    cd /tmp/work && \
    curl -fsSLO --compressed "https://github.com/sider/JavaSee/releases/download/${JAVASEE_VERSION}/JavaSee-bin-${JAVASEE_VERSION}.zip" && \
    unzip "JavaSee-bin-${JAVASEE_VERSION}.zip" && \
    mkdir "${RUNNER_USER_HOME}/JavaSee" && \
    cp -rv "JavaSee-bin-${JAVASEE_VERSION}/bin" "${RUNNER_USER_HOME}/JavaSee/bin" && \
    cp -rv "JavaSee-bin-${JAVASEE_VERSION}/lib" "${RUNNER_USER_HOME}/JavaSee/lib" && \
    ln -sv "${RUNNER_USER_HOME}/JavaSee/bin/javasee" "${RUNNER_USER_BIN}/javasee" && \
    cd .. && \
    rm -rf /tmp/work && \
    javasee version | grep "${JAVASEE_VERSION}"


# Copy the main source code
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} exe ${RUNNERS_DIR}/exe
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} lib ${RUNNERS_DIR}/lib

ENV PATH ${RUNNERS_DIR}/exe:${PATH}

# Run as non-root user
USER $RUNNER_USER
WORKDIR $RUNNER_USER_HOME

COPY images/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh", "runners", "--analyzer=javasee"]
