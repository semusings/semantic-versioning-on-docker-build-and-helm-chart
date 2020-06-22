set -e
option="${1}"
default_version='0.0.0-SNAPSHOT'
next_version="${2:-$default_version}"
case ${option} in
   --prepare)
      ./mvnw \
        -B -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn -V \
        clean install -Drevision="$next_version"
      ;;
   --publish)
      # Publish Docker in Github Packages
      DOCKER_PKG=docker.pkg.github.com/bhuwanupadhyay/semantic-versioning-on-docker-build-and-helm-chart/my-service:"$next_version"
      docker login docker.pkg.github.com -u BhuwanUpadhyay -p "$GITHUB_TOKEN"
      docker tag docker.io/bhuwanupadhyay/my-service:"$next_version" "$DOCKER_PKG"
      docker push "$DOCKER_PKG"

      # Publish Helm chart in Github Releases
      HELM_CHART="my-service-$next_version.tgz"
      HELM_CHART_FILE_PATH="$(pwd)/target/helm/repo/$FILE_NAME"

      # TODO: yourself
      # Write script to upload your helm chart in your Artifactory or chart museum.

      echo "Mock publish: $HELM_CHART from $HELM_CHART_FILE_PATH"
      ;;
   *)
      echo "`basename ${0}`:usage: [--prepare] | [--publish]"
      exit 1 # Command to come out of the program with status 1
      ;;
esac
