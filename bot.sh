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
      docker tag docker.io/bhuwanupadhyay/my-service:"$next_version" \
        docker.pkg.github.com/bhuwanupadhyay/semantic-versioning-on-docker-build-and-helm-chart/my-service:"$next_version"

      docker push docker.pkg.github.com/bhuwanupadhyay/semantic-versioning-on-docker-build-and-helm-chart/my-service:"$next_version"

      # Publish Helm chart in Github Releases
      curl "https://raw.githubusercontent.com/whiteinge/ok.sh/master/ok.sh" -o "ok.sh"
      chmod +x ok.sh
      USER="BhuwanUpadhyay"
      REPO="semantic-versioning-on-docker-build-and-helm-chart"
      TAG="v$next_version"
      FILE_NAME=my-service-"$next_version".tgz
      FILE_PATH="target/helm/repo/$next_version"

      # Find a release by tag then upload a file:
      ./ok.sh list_releases "$USER" "$REPO" \
          | awk -v "tag=$TAG" -F'\t' '$2 == tag { print $3 }' \
          | xargs -I@ ok.sh release "$USER" "$REPO" @ _filter='.upload_url' \
          | sed 's/{.*$/?name='"$FILE_NAME"'/' \
          | xargs -I@ ok.sh upload_asset @ "$FILE_PATH"
      ;;
   *)
      echo "`basename ${0}`:usage: [--prepare] | [--publish]"
      exit 1 # Command to come out of the program with status 1
      ;;
esac
