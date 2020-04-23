# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE. IT IS GENERATED.
# PLEASE UPDATE Dockerfile.erb INSTEAD OF THIS FILE.
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM sider/devon_rex_java:master AS builder

# NOTE: Download required dependency JAR files via maven-dependency-plugin.
#       Also, this image uses a build layer because Maven downloads too many files to `~/.m2` directory.
#
#       See https://maven.apache.org/plugins/maven-dependency-plugin/copy-dependencies-mojo.html
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/pmd_java/pom.xml ${RUNNER_USER_HOME}/pmd_java/pom.xml
RUN cd "${RUNNER_USER_HOME}/pmd_java" && \
    mvn --no-transfer-progress --batch-mode --threads 4 dependency:copy-dependencies -DoutputDirectory=.

FROM sider/devon_rex_java:master

COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} --from=builder ${RUNNER_USER_HOME}/pmd_java/*.jar ${RUNNER_USER_HOME}/pmd_java/
ENV CLASSPATH ${RUNNER_USER_HOME}/pmd_java/*:${CLASSPATH}

ARG RUNNERS_DIR=${RUNNER_USER_HOME}/runners

# Install required gems first (due to slow download)
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} Gemfile* analyzers.yml ${RUNNERS_DIR}/
RUN cd ${RUNNERS_DIR} && \
    bundle config set --global jobs 4 && \
    bundle config set --global retry 3 && \
    bundle config && \
    BUNDLE_WITHOUT=development:test bundle install && \
    bundle list

COPY images/pmd_java/pmd /usr/local/bin/

COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/pmd_java/default-ruleset.xml ${RUNNER_USER_HOME}/

# NOTE: PMD does not have a CLI option to show its version.
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/pmd_java/ShowPMDVersion.java ${RUNNER_USER_HOME}/work/
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} images/pmd_java/show_pmd_version ${RUNNER_USER_HOME}/work/
ENV PATH ${RUNNER_USER_HOME}/work:${PATH}
RUN cd "${RUNNER_USER_HOME}/work" && \
    javac ShowPMDVersion.java && \
    cd .. && \
    show_pmd_version


# Copy the main source code
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} bin ${RUNNERS_DIR}/bin
COPY --chown=${RUNNER_USER}:${RUNNER_GROUP} lib ${RUNNERS_DIR}/lib

ENV PATH ${RUNNERS_DIR}/bin:${PATH}

# Run as non-root user
USER $RUNNER_USER
WORKDIR $RUNNER_USER_HOME

ENTRYPOINT ["/usr/bin/timeout", "--signal=SIGUSR2", "--kill-after=10s", "30m", "runners", "--analyzer=pmd_java"]
