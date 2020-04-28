# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE. IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE.
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_dotnet:master

ENV FXCOP_VERSION=3.0.0

ARG ROSLYN_ANALYZERS_RUNNER_VERSION=0.1.4
ARG ROSLYN_ANALYZERS_RUNNER_HOME=${RUNNER_USER_HOME}/roslyn-analyzers-runner
ENV PATH ${ROSLYN_ANALYZERS_RUNNER_HOME}:$PATH

COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/fxcop/analyzers.json ${RUNNER_USER_HOME}/

RUN mkdir -p ${ROSLYN_ANALYZERS_RUNNER_HOME} && \
    curl -fsSL --compressed https://github.com/sider/roslyn-analyzers-runner/releases/download/v${ROSLYN_ANALYZERS_RUNNER_VERSION}/Sider.RoslynAnalyzersRunner.${ROSLYN_ANALYZERS_RUNNER_VERSION}.tar.gz \
      | tar -zxC ${ROSLYN_ANALYZERS_RUNNER_HOME} && \
    mv ${RUNNER_USER_HOME}/analyzers.json ${ROSLYN_ANALYZERS_RUNNER_HOME}/ && \
    sed -i -e"s/\${FXCOP_VERSION}/${FXCOP_VERSION}/" ${ROSLYN_ANALYZERS_RUNNER_HOME}/analyzers.json && \
    cd ${RUNNER_USER_HOME} && \
    mkdir dummy_project && \
    cd dummy_project && \
    dotnet new console && \
    dotnet add package Microsoft.CodeAnalysis.Analyzers --version ${FXCOP_VERSION} && \
    dotnet add package Microsoft.CodeAnalysis.FxCopAnalyzers --version ${FXCOP_VERSION} && \
    cd .. && \
    rm -rf dummy_project


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

ENTRYPOINT ["/usr/bin/timeout", "--signal=SIGUSR2", "--kill-after=10s", "30m", "runners", "--analyzer=fxcop"]
