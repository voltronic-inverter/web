### Process

- Install docker

### X86-64
```sh
docker run -t -i --rm -v `pwd`:/io phusion/holy-build-box-64:latest bash -c "curl 'https://raw.githubusercontent.com/voltronic-inverter/web/master/linux/holy_build_box.sh' | bash"
```

### X86-64
```sh
docker run -t -i --rm -v `pwd`:/io phusion/holy-build-box-32:latest linux32 bash -c "curl 'https://raw.githubusercontent.com/voltronic-inverter/web/master/linux/holy_build_box.sh' | linux32 bash"
```

[Look at it go](https://youtu.be/mew8AtH5wvU?t=14)