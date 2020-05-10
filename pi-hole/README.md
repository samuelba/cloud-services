# Pi Hole

The web interface is reachable via https://pi-hole.example.com/admin.

## Ubuntu as Host

See: https://github.com/pi-hole/docker-pi-hole#installing-on-ubuntu

```
sudo sed -r -i.orig 's/#?DNSStubListener=yes/DNSStubListener=no/g' /etc/systemd/resolved.conf
```

This will change the symlink from originally `/etc/resolv.conf -> ../run/systemd/resolve/stub-resolv.conf`

```
sudo sh -c 'rm /etc/resolv.conf && ln -s /run/systemd/resolve/resolv.conf /etc/resolv.conf'
```