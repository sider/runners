# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE. IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE.
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_java:2.40.1

# Install dependencies via Gradle
ARG DEPS_DIR=${RUNNER_USER_HOME}/dependencies
ENV CLASSPATH ${DEPS_DIR}/*:${CLASSPATH}
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/pmd_java/build.gradle ${DEPS_DIR}/
RUN cd "${DEPS_DIR}" && \
    echo 'task deps(type: Copy) {' >> build.gradle && \
    echo '  from configurations.runtimeClasspath' >> build.gradle && \
    echo '  into "."' >> build.gradle && \
    echo '}' >> build.gradle && \
    gradle --no-build-cache --parallel --quiet deps && \
    rm build.gradle

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
    lockfile_bundler_version=$(bundle exec ruby -e 'puts Bundler::LockfileParser.new(File.read "Gemfile.lock").bundler_version') && \
    bundle version | grep "Bundler version ${lockfile_bundler_version}"

COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/pmd_java/pmd ${RUNNER_USER_HOME}/bin/
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/pmd_java/default-ruleset.xml ${RUNNER_USER_HOME}/

# NOTE: PMD does not have a CLI option to show its version.
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/pmd_java/ShowPMDVersion.java ${RUNNER_USER_HOME}/bin/
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/pmd_java/show_pmd_version ${RUNNER_USER_HOME}/bin/
RUN cd "${RUNNER_USER_HOME}/bin" && \
    javac ShowPMDVersion.java && \
    rm ShowPMDVersion.java


# Copy the main source code
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} exe ${RUNNERS_DIR}/exe
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} lib ${RUNNERS_DIR}/lib

ENV PATH ${RUNNERS_DIR}/exe:${PATH}

# Run as non-root user
USER $RUNNER_USER
WORKDIR $RUNNER_USER_HOME

COPY images/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh", "runners", "--analyzer=pmd_java"]
