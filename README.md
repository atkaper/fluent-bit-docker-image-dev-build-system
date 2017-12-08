# Fluent Bit Docker Image - Developer Build System

This stuff is based on this: https://github.com/fluent/fluent-bit-docker-image
If you just want a standard release, I suggest to use the above project.

If however you want to do some development on fluent-bit, you could use this version for quick rebuilds while keeping a clean host machine.

Changes; other folder structure, and use GIT clone to get the latest fluent-bit sources.
Uses TWO separate Dockerfile's, one for re-usable compiles, and one for the final image build.
Keep sources and build results for re-use in multiple builds... Meant for people working on the source code.

Note: meant to be used on a linux machine, might work on windows using git-bash or some other "linux" simulation.


[Fluent Bit](http://fluentbit.io) Docker image based on Debian base image from Google.

## 1. Build image

First edit `settings.conf` file to use proper git repositoy, branch, and choose for compile in docker volume or local host folder.
Then use provided scripts to build the image. This names the image "local/fluent-bit" (you can re-tag it later if needed):

```
./1-compile.sh        # This creates a compiler container, does an initial one-time git clone, and optional git pull, and run's make.
./2-package.sh        # This packages the build result together with some configs from the conf folder into a runnable fluent-bit container.
```

## 2. Test it

Once the image is built, it's ready to run (see also step 3):

```
docker run --rm -p 127.0.0.1:24224:24224 local/fluent-bit
```

By default, the configuration sets a listener on TCP port 24224 through Forward protocol and prints to the standard output interface each message. So this can be used to forward Docker log messages from one container to the Fluent Bit image, e.g:

```
docker run --rm --log-driver=fluentd -t ubuntu echo "Testing a log message"
```
Note: the fluentd (yes -D, not -BIT) log-driver will send stdout logs to port 24224.


On Fluent Bit container should print to stdout something like this:

```
Fluent-Bit v#.#.#
Copyright (C) Treasure Data

[0] docker.31c94ceb86ca: [1487548735, {"container_id"=>"31c94ceb86cae7055564eb4d65cd2e2897addd252fe6b86cd11bddd70a871c08", "container_name"=>"/admiring_shannon", "source"=>"stdout","}]og"=>"Testing a log message
```

## 3. Some more scripts
```
3-test-run-fluent-bit-dummy-input.sh         # simple test run with dummy input
4-test-run-fluent-bit-server.sh              # same test run as from step 2
9-destroy-docker-source-volume.sh            # for cleanup of cloned sources (if docker volume used)
```


## Contact

Feel free to join on Mailing List or IRC to reach the fluent-bit people:

 - Slack: http://slack.fluentd.org / channel #fluent-bit
 - Mailing List: https://groups.google.com/forum/#!forum/fluent-bit
 - IRC: irc.freenode.net #fluent-bit
 - Twitter: http://twitter.com/fluentbit

## License

Note: this next line and LICENSE file just copy/pasted from the original project, I have not read them at all...
This program is under the terms of the [Apache License v2.0](http://www.apache.org/licenses/LICENSE-2.0).

## Authors

[Fluent Bit](http://fluentbit.io) is made and sponsored by [Treasure Data](http://treasuredata.com) among other [contributors](https://github.com/fluent/fluent-bit/graphs/contributors).

Note: this double Docker container builder modified version can be found on https://github.com/atkaper/

