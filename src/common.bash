set -eo pipefail

[[ "$TRACE" ]] && set -x

export CI_CONTAINER_NAME="ci_job_build_$CI_BUILD_ID"
export CI_REGISTRY_TAG="$CI_BUILD_REF_SLUG"

ensure_environment_url() {
  # [[ -n "$CI_ENVIRONMENT_URL" ]] && return

  echo "Reading CI_ENVIRONMENT_URL from .gitlab-ci.yml..."
  CI_ENVIRONMENT_URL="$(ruby -ryaml -e 'puts YAML.load_file(".gitlab-ci.yml")[ENV["CI_BUILD_NAME"]]["environment"]["url"]')"
  CI_ENVIRONMENT_URL="$(eval echo "$CI_ENVIRONMENT_URL")"
  echo "CI_ENVIRONMENT_URL: $CI_ENVIRONMENT_URL"
}

ensure_docker_engine() {
  if ! docker info &>/dev/null; then
    echo "Missing docker engine to build images."
    echo "Running docker:dind locally with graph driver pointing to '/cache/docker'"

    if ! grep -q overlay /proc/filesystems; then
      echo "Missing overlay filesystem. Are you running recent enough kernel?"
      exit 1
    fi

    if [[ ! -d /cache ]]; then
      mkdir -p /cache
      mount -t tmpfs tmpfs /cache
    fi

    dockerd \
      --host=unix:///var/run/docker.sock \
      --storage-driver=overlay \
      --graph=/cache/docker & &>/docker.log

    trap 'kill %%' EXIT

    echo "Waiting for docker..."
    for i in $(seq 1 60); do
      if docker info &> /dev/null; then
        break
      fi
      sleep 1s
    done

    if [[ "$i" == 60 ]]; then
      echo "Failed to start docker:dind..."
      cat /docker.log
      exit 1
    fi
    echo ""
  fi
}
