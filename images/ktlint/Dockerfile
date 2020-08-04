# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE. IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE.
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_java:2.24.0

# Install dependencies via Gradle
ARG DEPS_DIR=${RUNNER_USER_HOME}/dependencies
ENV CLASSPATH ${DEPS_DIR}/*:${CLASSPATH}
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/ktlint/build.gradle ${DEPS_DIR}/
RUN cd "${DEPS_DIR}" && \
    echo 'task deps(type: Copy) {' >> build.gradle && \
    echo '  from configurations.runtimeClasspath' >> build.gradle && \
    echo '  into "."' >> build.gradle && \
    echo '}' >> build.gradle && \
    gradle --no-build-cache --parallel --quiet deps && \
    rm build.gradle

COPY images/ktlint/ktlint /usr/local/bin/


ARG RUNNERS_DIR=${RUNNER_USER_HOME}/runners

# Install required gems first (due to slow download)
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} Gemfile* analyzers.yml ${RUNNERS_DIR}/
RUN cd ${RUNNERS_DIR} && \
    bundle config set --global jobs 4 && \
    bundle config set --global retry 3 && \
    bundle config && \
    BUNDLE_WITHOUT=development:test bundle install && \
    bundle list

# Copy the main source code
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} bin ${RUNNERS_DIR}/bin
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} lib ${RUNNERS_DIR}/lib

ENV PATH ${RUNNERS_DIR}/bin:${PATH}

# Run as non-root user
USER $RUNNER_USER
WORKDIR $RUNNER_USER_HOME

ENTRYPOINT ["/usr/bin/timeout", "--signal=SIGUSR2", "--kill-after=10s", "30m", "runners", "--analyzer=ktlint"]
