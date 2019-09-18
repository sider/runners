# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_java:2.2.0

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

ENV PMD_VERSION 6.17.0
USER root
RUN curl -SL https://github.com/pmd/pmd/releases/download/pmd_releases%2F${PMD_VERSION}/pmd-bin-${PMD_VERSION}.zip > pmd-bin-${PMD_VERSION}.zip \
    && unzip pmd-bin-${PMD_VERSION}.zip \
    && mv pmd-bin-${PMD_VERSION} /usr/local/pmd \
    && rm pmd-bin-${PMD_VERSION}.zip

USER $RUNNER_USER

USER root
RUN chown -R ${RUNNER_USER}: ${RUNNER_USER_HOME}
USER $RUNNER_USER

ENTRYPOINT ["runners", "--analyzer=pmd_java"]
