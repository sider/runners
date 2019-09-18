# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_ruby:2.2.0

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

# Install the latest version for caching
RUN gem install haml_lint -v 0.32.0 && \
    gem install rubocop -v 0.71.0 && \
    gem install rubocop-rspec -v 1.33.0 && \
    gem install rubocop-rails -v 2.0.1 && \
    gem install meowcop -v 1.20.0

COPY images/haml_lint/default_rubocop.yml $RUNNER_USER_HOME/

USER root
RUN chown -R ${RUNNER_USER}: ${RUNNER_USER_HOME}
USER $RUNNER_USER

ENTRYPOINT ["runners", "--analyzer=haml_lint"]
