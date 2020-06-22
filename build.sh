option="${1}"
case ${option} in
   --build)
      ./mvnw \
        -B -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn -V \
        clean install
      ;;
   --release)

      ;;
   *)
      echo "`basename ${0}`:usage: [--build] | [--release]"
      exit 1 # Command to come out of the program with status 1
      ;;
esac
