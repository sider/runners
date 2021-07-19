# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE. IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE.
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM python:3-slim-buster AS cppcheck

# NOTE: The reason using Python image: when setting `MATCHCOMPILER=yes`, Python is used to optimise cppcheck.
#       See <https://github.com/danmar/cppcheck/blob/6cb8f877981a491465aba2f9ffb00d6142f6f852/readme.md#gnu-make>

ARG CPPCHECK_VERSION=2.5

# NOTE: A segmentation fault occurs with the latest version of libz3.
ARG LIBZ3_VERSION=4.4.1-1~deb10u1

RUN apt-get update && \
    apt-get install -qq -y --no-install-recommends \
      curl \
      g++ \
      make \
      libpcre3-dev \
      "libz3-dev=${LIBZ3_VERSION}" && \
    rm -rf /var/lib/apt/lists/* && \
    cd /tmp && \
    curl -sSL --compressed "https://github.com/danmar/cppcheck/archive/${CPPCHECK_VERSION}.tar.gz" | tar -xz && \
    cd "cppcheck-${CPPCHECK_VERSION}" && \
    # NOTE: We cannot use the latest version due to a potential segmentation fault.
    cp -v externals/z3_version_old.h externals/z3_version.h && \
    make "-j$(nproc)" --silent install \
      MATCHCOMPILER=yes \
      PREFIX=/opt/cppcheck \
      FILESDIR=/opt/cppcheck/share \
      HAVE_RULES=yes \
      USE_Z3=yes \
      CXXFLAGS="-O2 -DNDEBUG -Wall -Wno-sign-compare -Wno-unused-function"

FROM sider/devon_rex_base:master


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

# See above.
ARG LIBZ3_VERSION=4.4.1-1~deb10u1

USER root
RUN apt-get update && \
    apt-get install -qq -y --no-install-recommends \
      "libz3-dev=${LIBZ3_VERSION}" && \
    rm -rf /var/lib/apt/lists/*
COPY --from=cppcheck /opt/cppcheck /opt/cppcheck
ENV PATH /opt/cppcheck/bin:${PATH}

COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/cppcheck/sider_recommended_cppcheck.txt ${RUNNER_USER_HOME}/


# Copy the main source code
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} exe ${RUNNERS_DIR}/exe
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} lib ${RUNNERS_DIR}/lib

ENV PATH ${RUNNERS_DIR}/exe:${PATH}

# Run as non-root user
USER $RUNNER_USER
WORKDIR $RUNNER_USER_HOME

COPY images/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh", "runners", "--analyzer=cppcheck"]
