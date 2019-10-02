# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_ruby:2.3.0

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
ENV PATH ${RUNNERS_DIR}/bin:${PATH}

# Install the default version
COPY images/goodcheck/Gemfile ${RUNNER_USER_HOME}/goodcheck_Gemfile
RUN cd ${RUNNER_USER_HOME} && \
    mkdir goodcheck && \
    mv goodcheck_Gemfile goodcheck/Gemfile && \
    cd goodcheck && \
    bundle install --system --gemfile=Gemfile && \
    rbenv rehash && \
    cd ${RUNNER_USER_HOME} && \
    rm -rf goodcheck && \
    gem list goodcheck
USER root
RUN chown -R ${RUNNER_USER}: ${RUNNER_USER_HOME}
USER $RUNNER_USER

ENTRYPOINT ["runners", "--analyzer=goodcheck"]
