# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE. IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE.
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_php:master


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

# Install PHP packages via Composer
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/code_sniffer/composer.* ${COMPOSER_HOME}/
RUN composer global install

# Set install paths
RUN basepath="${COMPOSER_HOME}/vendor" && \
    phpcs --config-set installed_paths \
      "${basepath}/cakephp/cakephp-codesniffer,${basepath}/escapestudios/symfony2-coding-standard,${basepath}/wp-coding-standards/wpcs" && \
    phpcs -i

COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/code_sniffer/sider_recommended_code_sniffer.xml ${RUNNER_USER_HOME}/


# Copy the main source code
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} exe ${RUNNERS_DIR}/exe
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} lib ${RUNNERS_DIR}/lib

ENV PATH ${RUNNERS_DIR}/exe:${PATH}

# Run as non-root user
USER $RUNNER_USER
WORKDIR $RUNNER_USER_HOME

COPY images/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh", "runners", "--analyzer=code_sniffer"]
