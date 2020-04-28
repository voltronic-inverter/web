# Using Ubuntu

- Install docker

```sh
docker run -t -i --rm -v `pwd`:/io ubuntu:focal bash -c "apt clean && apt update && apt install -y curl && curl -L 'https://raw.githubusercontent.com/voltronic-inverter/web/master/windows/ubuntu_docker_build.sh' | bash"
```

Watch it go