# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE. IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE.
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_base:2.26.0

COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/clang_tidy/packages.list ${RUNNER_USER_HOME}/

USER root
RUN curl -fsSL https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
    add-apt-repository "deb http://apt.llvm.org/buster/ llvm-toolchain-buster-10 main" && \
    apt-get update && \
    grep -v "^\s*#" ${RUNNER_USER_HOME}/packages.list | xargs apt-get install -qq -y --no-install-recommends && \
    apt-get clean && \
    update-alternatives --install /usr/local/bin/clang-tidy clang-tidy /usr/lib/llvm-10/bin/clang-tidy 20 && \
    echo "${RUNNER_USER} ALL=NOPASSWD: /usr/bin/apt-get" > /etc/sudoers.d/runner
USER $RUNNER_USER


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

COPY images/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh", "runners", "--analyzer=clang_tidy"]
