# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_swift:2.2.0

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

ENV SWIFTLINT_VERSION="0.34.0"
ARG SWIFTLINT_BUILD_DIR="/swiftlint_build"

# Build SwiftLint
USER root
RUN git clone --branch ${SWIFTLINT_VERSION} --single-branch https://github.com/realm/SwiftLint.git ${SWIFTLINT_BUILD_DIR} && \
    cd ${SWIFTLINT_BUILD_DIR} && \
    git submodule update --init --recursive && \
    make install && \
    cd / && \
    rm -rf "${SWIFTLINT_BUILD_DIR}"

USER $RUNNER_USER

ENTRYPOINT ["runners", "--analyzer=swiftlint"]
