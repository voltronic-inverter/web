### Process

- Install docker

```sh
docker run -t -i --rm -v `pwd`:/io phusion/holy-build-box-64:latest bash -c "curl 'https://raw.githubusercontent.com/voltronic-inverter/web/master/linux/holy-build-box-build.sh' | bash"
```

Watch it go