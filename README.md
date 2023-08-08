# docker-snort3

Snort 3 implementation for Docker.

# Docker example usage

This docker implementation is tested with the following command line, that allows you to use snort as it is installed on your machine. This way, you can intercept traffic on your host machine.

```
$ docker run --rm --name snort3 --net=host --cap-add=NET_ADMIN -d snort3
```

You could pass SNORT_INTERFACE environment variable if you want to specify the name of the interface.

```
$ docker run --rm --name snort3 --net=host --cap-add=NET_ADMIN -d -e SNORT_INTERFACE=enp3s0  snort3 
```

# Customization

There is a custom.rules file included in this repository that you could modify and then build again to add your own rules. 

The steps to make it work would be:

```bash
git clone https://github.com/eaguad1337/snort3-docker.git
cd snort3-docker

# add rules to custom.rules

docker build . -t my-snort3
```

Then you could run your custom image referring to your custom image named ```my-snort3```

```
$ docker run --rm --name snort3 --net=host --cap-add=NET_ADMIN -d -e SNORT_INTERFACE=enp3s0 my-snort3 
```