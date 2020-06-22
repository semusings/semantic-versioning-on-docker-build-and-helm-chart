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
      # Publish Docker by login
      # docker login -u developerbhuwan -p "$DOCKER_PASSWORD"
      # docker push docker.io/bhuwanupadhyay/my-service:"$next_version"

      # Publish Docker in Github Packages <https://github.com/BhuwanUpadhyay/semantic-versioning-on-docker-build-and-helm-chart/packages>
      DOCKER_PKG=docker.pkg.github.com/bhuwanupadhyay/semantic-versioning-on-docker-build-and-helm-chart/my-service:"$next_version"
      docker login docker.pkg.github.com -u BhuwanUpadhyay -p "$GITHUB_TOKEN"
      docker tag docker.io/bhuwanupadhyay/my-service:"$next_version" "$DOCKER_PKG"
      docker push "$DOCKER_PKG"

      # Publish Helm chart in Github Releases
      USER="BhuwanUpadhyay"
      REPO="semantic-versioning-on-docker-build-and-helm-chart"
      TAG="v$next_version"
      FILE_NAME="my-service-$next_version.tgz"
      FILE_PATH="$(pwd)/target/helm/repo/$FILE_NAME"
      GH_ASSET="https://uploads.github.com/repos/$USER/$REPO/releases/$TAG/assets?name=$FILE_NAME"
      curl --data-binary @"$FILE_PATH" \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Content-Type: application/octet-stream" "$GH_ASSET"
      ;;
   *)
      echo "`basename ${0}`:usage: [--prepare] | [--publish]"
      exit 1 # Command to come out of the program with status 1
      ;;
esac
