# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_java:2.6.0

ARG JAVASEE_VERSION=0.1.2
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
COPY Gemfile* ${RUNNERS_DIR}/
USER root
RUN chown -R ${RUNNER_USER}: ${RUNNERS_DIR}
USER $RUNNER_USER
RUN cd ${RUNNERS_DIR} && \
    bundle config --global jobs 4 && \
    bundle config --global retry 3 && \
    bundle config && \
    bundle install --without='development test'
ENV PATH ${RUNNERS_DIR}/bin:${PATH}
# Copy the main source code
COPY bin ${RUNNERS_DIR}/bin
COPY lib ${RUNNERS_DIR}/lib

# Change owner and group of all files
USER root
RUN chown -R ${RUNNER_USER}: ${RUNNER_USER_HOME}
USER $RUNNER_USER

ENTRYPOINT ["/usr/bin/timeout", "--signal=SIGUSR2", "--kill-after=10s", "30m", "runners", "--analyzer=javasee"]
