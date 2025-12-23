# harness

```console
$ ./run.sh
```

will run:

```console
docker run -d \
  -p 3000:3000 -p 3022:3022 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /tmp/harness:/data \
  --name opensource \
  --restart always \
  harness/harness
```

## Links

- https://developer.harness.io/docs/open-source/installation/quick-start/
- https://github.com/harness
- https://github.com/harness-community/