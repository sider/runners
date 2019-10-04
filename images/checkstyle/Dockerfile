# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

FROM sider/devon_rex_java:2.4.0 AS builder

# NOTE: Download required dependency JAR files via maven-dependency-plugin.
#       Also, this image uses a build layer because Maven downloads too many files to `~/.m2` directory.
#
#       See https://maven.apache.org/plugins/maven-dependency-plugin/copy-dependencies-mojo.html
USER root
COPY images/checkstyle/pom.xml ${RUNNER_USER_HOME}/checkstyle/pom.xml
RUN cd "${RUNNER_USER_HOME}/checkstyle" && \
    mvn -ntp -B -T 4 dependency:copy-dependencies -DoutputDirectory=.

FROM sider/devon_rex_java:2.4.0

COPY --from=builder ${RUNNER_USER_HOME}/checkstyle/*.jar ${RUNNER_USER_HOME}/checkstyle/
ENV CLASSPATH ${RUNNER_USER_HOME}/checkstyle/*:${CLASSPATH}

COPY images/checkstyle/checkstyle /usr/local/bin/

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
USER root
RUN chown -R ${RUNNER_USER}: ${RUNNER_USER_HOME}
USER $RUNNER_USER

ENTRYPOINT ["runners", "--analyzer=checkstyle"]
