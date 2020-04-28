# Using Ubuntu

- Install docker

```sh
docker run -t -i --rm -v `pwd`:/io ubuntu:focal bash -c "curl 'https://raw.githubusercontent.com/voltronic-inverter/web/master/windows/linux-docker-build.sh' | bash"
```

Watch it go