### Process

- Install docker

### X86-64
```sh
docker run -t -i --rm -v `pwd`:/io phusion/holy-build-box-64:latest bash -c "curl 'https://raw.githubusercontent.com/voltronic-inverter/web/master/linux/holy-build-box-build.sh' | bash"
```

### X86-64
```
docker run -t -i --rm -v `pwd`:/io phusion/holy-build-box-32:latest linux32 bash -c "curl 'https://raw.githubusercontent.com/voltronic-inverter/web/master/linux/holy-build-box-build.sh' | linux32 bash"
```

Watch it go