# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_go:2.2.0

ARG RUNNERS_DIR=${RUNNER_USER_HOME}/runners
COPY Gemfile* Rakefile ${RUNNERS_DIR}/
COPY bin ${RUNNERS_DIR}/bin
COPY lib ${RUNNERS_DIR}/lib
USER root
RUN chown -R ${RUNNER_USER}: ${RUNNERS_DIR}
USER $RUNNER_USER

RUN cd ${RUNNERS_DIR} && \
    bundle config --global jobs 4 && \
    bundle config --global retry 3 && \
    bundle config && \
    bundle install --without='development test'
ENV BUNDLE_GEMFILE ${RUNNERS_DIR}/Gemfile
ENV PATH ${RUNNERS_DIR}/bin:${PATH}

ARG LINT_TOOL_VERSION="2.0.11"

USER root
RUN curl -L https://github.com/alecthomas/gometalinter/releases/download/v${LINT_TOOL_VERSION}/gometalinter-${LINT_TOOL_VERSION}-linux-amd64.tar.gz | \
    tar -xzC . && \
    cd gometalinter-${LINT_TOOL_VERSION}-linux-amd64/ && \
    rm COPYING README.md && \
    mv * /usr/local/bin/ && \
    cd .. && \
    rm -r gometalinter-${LINT_TOOL_VERSION}-linux-amd64/
USER $RUNNER_USER

COPY images/gometalinter/gometalinter.json $RUNNER_USER_HOME/
ENTRYPOINT ["runners", "--analyzer=gometalinter"]
