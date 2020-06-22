option="${1}"
next_version="${2}"
case ${option} in
   --prepare)
      ./mvnw \
        -B -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn -V \
        clean install -Drevision="$next_version"
      ;;
   --publish)
      docker push docker.io/bhuwanupadhyay/my-service:"$next_version"
      ;;
   *)
      echo "`basename ${0}`:usage: [--prepare] | [--publish]"
      exit 1 # Command to come out of the program with status 1
      ;;
esac
