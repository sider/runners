# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE. IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE.
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_java:2.42.2

# Install dependencies via Gradle
ARG DEPS_DIR=${RUNNER_USER_HOME}/dependencies
ENV CLASSPATH ${DEPS_DIR}/*:${CLASSPATH}
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/checkstyle/build.gradle ${DEPS_DIR}/
RUN cd "${DEPS_DIR}" && \
    echo 'task deps(type: Copy) {' >> build.gradle && \
    echo '  from configurations.runtimeClasspath' >> build.gradle && \
    echo '  into "."' >> build.gradle && \
    echo '}' >> build.gradle && \
    gradle --no-build-cache --parallel --quiet deps && \
    rm build.gradle

COPY images/checkstyle/checkstyle /usr/local/bin/
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/checkstyle/sider_recommended_checkstyle.xml ${RUNNER_USER_HOME}/


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

# Copy the main source code
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} exe ${RUNNERS_DIR}/exe
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} lib ${RUNNERS_DIR}/lib

ENV PATH ${RUNNERS_DIR}/exe:${PATH}

# Run as non-root user
USER $RUNNER_USER
WORKDIR $RUNNER_USER_HOME

COPY images/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh", "runners", "--analyzer=checkstyle"]
