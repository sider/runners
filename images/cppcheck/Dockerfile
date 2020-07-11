# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE. IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE.
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_python:2.22.0

# NOTE: The reason using Python image: when setting `MATCHCOMPILER=yes`, Python is used to optimise cppcheck.
#
# See https://github.com/danmar/cppcheck#gnu-make

ARG CPPCHECK_VERSION=2.1

# NOTE: A segmentation fault occurs with the latest version of libz3.
ARG LIBZ3_VERSION=4.4.1-1~deb10u1

USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends libz3-dev=${LIBZ3_VERSION} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    cd /tmp && \
    curl -sSL https://github.com/danmar/cppcheck/archive/${CPPCHECK_VERSION}.tar.gz | tar -xz && \
    cd cppcheck-${CPPCHECK_VERSION} && \
    # NOTE: We cannot use the latest version due to a potential segmentation fault.
    cp -v externals/z3_version_old.h externals/z3_version.h && \
    make install -s \
      MATCHCOMPILER=yes \
      FILESDIR=/usr/share/cppcheck \
      HAVE_RULES=yes \
      USE_Z3=yes \
      CPPFLAGS="-DUSE_Z3 -Wno-deprecated-declarations -Wno-unused-function" && \
    rm -rf cppcheck-${CPPCHECK_VERSION}


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

ENTRYPOINT ["/usr/bin/timeout", "--signal=SIGUSR2", "--kill-after=10s", "30m", "runners", "--analyzer=cppcheck"]
