# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_python:2.2.0

# NOTE: The reason using Python image: when setting `MATCHCOMPILER=yes`, Python is used to optimise cppcheck.
#
# See https://github.com/danmar/cppcheck#gnu-make

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

ARG CPPCHECK_VERSION=1.89

USER root
RUN cd /tmp \
  && curl -sSL https://github.com/danmar/cppcheck/archive/${CPPCHECK_VERSION}.tar.gz \
  |  tar -xz \
  && cd cppcheck-${CPPCHECK_VERSION} \
  && make install -s MATCHCOMPILER=yes FILESDIR=/usr/share/cppcheck HAVE_RULES=yes CXXFLAGS="-O2 -DNDEBUG -Wall -Wno-sign-compare -Wno-unused-function" \
  && rm -rf cppcheck-${CPPCHECK_VERSION}
USER $RUNNER_USER

ENTRYPOINT ["runners", "--analyzer=cppcheck"]
