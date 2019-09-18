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

RUN gem install rails_best_practices -v 1.19.4 && \
    gem install slim -v 4.0.1 && \
    gem install haml -v 5.0.4 && \
    gem install sass -v 3.7.3 && \
    gem install sassc -v 2.0.1 && \
    gem install require_all:1.5.0 require_all:2.0.0

COPY images/rails_best_practices/sider_rails_best_practices.yml $RUNNER_USER_HOME/

USER root
RUN chown -R ${RUNNER_USER}: ${RUNNER_USER_HOME}
USER $RUNNER_USER

ENTRYPOINT ["runners", "--analyzer=rails_best_practices"]
