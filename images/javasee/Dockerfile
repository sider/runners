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

ENV JAVASEE_VERSION 0.1.1
USER root
RUN curl -O -L https://github.com/sider/JavaSee/releases/download/${JAVASEE_VERSION}/JavaSee-bin-${JAVASEE_VERSION}.zip \
  && unzip JavaSee-bin-${JAVASEE_VERSION}.zip \
  && mv JavaSee-${JAVASEE_VERSION} /usr/local/JavaSee \
  && ln -s /usr/local/JavaSee/bin/javasee /usr/local/bin/javasee \
  && rm -rf *.zip

USER $RUNNER_USER

ENTRYPOINT ["runners", "--analyzer=javasee"]
