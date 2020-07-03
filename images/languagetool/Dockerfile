# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE. IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE.
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_java:2.21.0

ARG LANGUAGETOOL_VERSION=5.0

RUN cd "${RUNNER_USER_HOME}" && \
    curl -sSLO --compressed https://languagetool.org/download/LanguageTool-${LANGUAGETOOL_VERSION}.zip && \
    unzip -q LanguageTool-${LANGUAGETOOL_VERSION}.zip && \
    rm LanguageTool-${LANGUAGETOOL_VERSION}.zip && \
    mv LanguageTool-${LANGUAGETOOL_VERSION} LanguageTool

ARG LANGUAGETOOL_HOME=${RUNNER_USER_HOME}/LanguageTool

COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/languagetool/languagetool ${LANGUAGETOOL_HOME}/

ENV CLASSPATH ${LANGUAGETOOL_HOME}/*:${CLASSPATH}
ENV PATH ${LANGUAGETOOL_HOME}:${PATH}


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

ENTRYPOINT ["/usr/bin/timeout", "--signal=SIGUSR2", "--kill-after=10s", "30m", "runners", "--analyzer=languagetool"]
