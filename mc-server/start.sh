#!/usr/bin/env bash

get_latest_spigot() {
  # Usamos un mirror que suele permitir descargas directas
  SPIGOT_URL="https://cdn.getbukkit.org/spigot/spigot-1.21.8.jar"
  
  printf "%s\n" "Intentando descargar desde mirror..."
  
  # Eliminamos el archivo viejo si existe para evitar conflictos
  rm -f spigot.jar
  
  # Descarga con User-Agent para saltar protecciones básicas
  wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64)" \
       --no-check-certificate \
       -O spigot.jar "$SPIGOT_URL"

  # Verificación rápida de tamaño
  if [ ! -f spigot.jar ] || [ $(stat -c%s "spigot.jar") -lt 1000000 ]; then
      printf "%s\n" "ERROR: No se pudo descargar el JAR. El link ha expirado o está bloqueado."
      exit 1
  fi
  
  sha256sum spigot.jar > papersha256.txt
}

AIKAR_FLAGS_CONSTANT="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true"
ZGC_FLAGS_CONSTANT="-XX:+UseZGC -XX:+IgnoreUnrecognizedVMOptions -XX:+UnlockExperimentalVMOptions -XX:+UnlockDiagnosticVMOptions -XX:-OmitStackTraceInFastThrow -XX:+ShowCodeDetailsInExceptionMessages -XX:+DisableExplicitGC -XX:-UseParallelGC -XX:-UseParallelOldGC -XX:+PerfDisableSharedMem -XX:-ZUncommit -XX:ZUncommitDelay=300 -XX:ZCollectionInterval=5 -XX:ZAllocationSpikeTolerance=2.0 -XX:+AlwaysPreTouch -XX:+UseTransparentHugePages -XX:LargePageSizeInBytes=2M -XX:+UseLargePages -XX:+ParallelRefProcEnabled"

wget --quiet --spider https://google.com 2>&1
if [ $? -eq 1 ]; then
  echo "No internet access - exiting"
  sleep 10
  exit 1
fi

# Ajuste de variables por defecto
if [[ -z "$JAR_FILE" ]]; then
  JAR_FILE="spigot.jar"
fi

if [[ -z "$RAM" ]]; then
  RAM="12G"
fi

if [[ -z "$FLAGS" ]]; then
  if [[ -n "$AIKAR_FLAGS" ]]; then
    FLAGS="$AIKAR_FLAGS_CONSTANT"
  elif [[ -n "$ZGC_FLAGS" ]]; then
    FLAGS="$ZGC_FLAGS_CONSTANT"
  fi
fi

printf "\n\n%s\n\n" "Starting Spigot Server..."

if [[ ! -e "/servercache/copied.txt" ]]; then
    printf "%s\n" "Copying config"
    cp -R /serverfiles /usr/src/
    touch /servercache/copied.txt
fi

cd /usr/src/serverfiles/ || exit

if [[ ! -e "$JAR_FILE" ]]; then
    printf "%s\n" "No $JAR_FILE found."
    get_latest_spigot
fi

if [[ -z "$CUSTOM_COMMAND" ]]; then
  printf "%s\n" "Starting JAR file: $JAR_FILE with $RAM of RAM"
  java -Xms$RAM -Xmx$RAM $FLAGS -jar $JAR_FILE nogui
else
  $CUSTOM_COMMAND
fi

sleep 10