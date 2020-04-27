# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE. IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE.
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_java:master

ARG JAVASEE_VERSION=0.1.3

RUN cd /tmp && \
    curl -fsSLO --compressed https://github.com/sider/JavaSee/releases/download/${JAVASEE_VERSION}/JavaSee-bin-${JAVASEE_VERSION}.zip && \
    unzip JavaSee-bin-${JAVASEE_VERSION}.zip && \
    mkdir ${RUNNER_USER_HOME}/JavaSee && \
    cp -rv JavaSee-${JAVASEE_VERSION}/bin ${RUNNER_USER_HOME}/JavaSee/bin && \
    cp -rv JavaSee-${JAVASEE_VERSION}/lib ${RUNNER_USER_HOME}/JavaSee/lib && \
    ln -sv ${RUNNER_USER_HOME}/JavaSee/bin/javasee ${RUNNER_USER_HOME}/bin/javasee && \
    rm JavaSee-bin-${JAVASEE_VERSION}.zip && \
    rm -r JavaSee-${JAVASEE_VERSION} && \
    javasee version


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

ENTRYPOINT ["/usr/bin/timeout", "--signal=SIGUSR2", "--kill-after=10s", "30m", "runners", "--analyzer=javasee"]
