# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE. IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE.
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_java:2.15.0

ARG JAVASEE_VERSION=0.1.3
USER root
RUN mkdir /tmp/javasee_work && \
    cd /tmp/javasee_work && \
    curl -sSLO https://github.com/sider/JavaSee/releases/download/${JAVASEE_VERSION}/JavaSee-bin-${JAVASEE_VERSION}.zip && \
    unzip JavaSee-bin-${JAVASEE_VERSION}.zip && \
    mv JavaSee-${JAVASEE_VERSION} /usr/local/JavaSee && \
    ln -s /usr/local/JavaSee/bin/javasee /usr/local/bin/javasee && \
    cd /tmp && \
    rm -rf /tmp/javasee_work && \
    javasee version


ARG RUNNERS_DIR=${RUNNER_USER_HOME}/runners

# Install required gems first (due to slow download)
COPY --chown=analyzer_runner:nogroup Gemfile* ${RUNNERS_DIR}/
RUN cd ${RUNNERS_DIR} && \
    bundle config --global jobs 4 && \
    bundle config --global retry 3 && \
    bundle config --local without development:test && \
    bundle config && \
    bundle install

# Copy the main source code
COPY --chown=analyzer_runner:nogroup bin ${RUNNERS_DIR}/bin
COPY --chown=analyzer_runner:nogroup lib ${RUNNERS_DIR}/lib

ENV PATH ${RUNNERS_DIR}/bin:${PATH}

# Run as non-root user
USER $RUNNER_USER
WORKDIR $RUNNER_USER_HOME

ENTRYPOINT ["/usr/bin/timeout", "--signal=SIGUSR2", "--kill-after=10s", "30m", "runners", "--analyzer=javasee"]
