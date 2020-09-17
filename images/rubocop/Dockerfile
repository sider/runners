# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE. IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE.
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_ruby:2.26.1


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
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/rubocop/Gemfile ${RUNNER_USER_HOME}/rubocop_Gemfile
RUN cd ${RUNNER_USER_HOME} && \
    mkdir rubocop && \
    mv rubocop_Gemfile rubocop/Gemfile && \
    cd rubocop && \
    bundle config set --local system 'true' && \
    bundle install --gemfile=Gemfile && \
    bundle config unset --local system && \
    cd ${RUNNER_USER_HOME} && \
    rm -rf rubocop && \
    gem info rubocop

COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/rubocop/default_rubocop.yml ${RUNNER_USER_HOME}/


# Copy the main source code
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} bin ${RUNNERS_DIR}/bin
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} lib ${RUNNERS_DIR}/lib

ENV PATH ${RUNNERS_DIR}/bin:${PATH}

# Run as non-root user
USER $RUNNER_USER
WORKDIR $RUNNER_USER_HOME

COPY images/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh", "runners", "--analyzer=rubocop"]
