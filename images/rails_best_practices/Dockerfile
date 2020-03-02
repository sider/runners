# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE. IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE.
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_ruby:2.15.0


ARG RUNNERS_DIR=${RUNNER_USER_HOME}/runners

# Install required gems first (due to slow download)
COPY --chown=analyzer_runner:nogroup Gemfile* ${RUNNERS_DIR}/
RUN cd ${RUNNERS_DIR} && \
    bundle config --global jobs 4 && \
    bundle config --global retry 3 && \
    bundle config --local without development:test && \
    bundle config && \
    bundle install

# Install the default version
COPY --chown=analyzer_runner:nogroup images/rails_best_practices/Gemfile ${RUNNER_USER_HOME}/rails_best_practices_Gemfile
RUN cd ${RUNNER_USER_HOME} && \
    mkdir rails_best_practices && \
    mv rails_best_practices_Gemfile rails_best_practices/Gemfile && \
    cd rails_best_practices && \
    bundle install --system --gemfile=Gemfile && \
    rbenv rehash && \
    cd ${RUNNER_USER_HOME} && \
    rm -rf rails_best_practices && \
    gem list rails_best_practices

# For backward compatibility
RUN gem install require_all:1.5.0

COPY --chown=analyzer_runner:nogroup images/rails_best_practices/sider_rails_best_practices.yml ${RUNNER_USER_HOME}/


# Copy the main source code
COPY --chown=analyzer_runner:nogroup bin ${RUNNERS_DIR}/bin
COPY --chown=analyzer_runner:nogroup lib ${RUNNERS_DIR}/lib

ENV PATH ${RUNNERS_DIR}/bin:${PATH}

# Run as non-root user
USER $RUNNER_USER
WORKDIR $RUNNER_USER_HOME

ENTRYPOINT ["/usr/bin/timeout", "--signal=SIGUSR2", "--kill-after=10s", "30m", "runners", "--analyzer=rails_best_practices"]
