nodejs-build-agent
==================

nodejs-build-agent is a "docker in docker" image designed as a tool for building Dockerized node.js projects hosted in git repositories.

How it works
------------

The running nodejs-build-agent container links through to the host machine's docker instance via volume mapping to ```/var/run/docker.sock``` pipe.
This gives the running container access to the hosts docker instance without having to actually include docker within the 
build agent image.

Build Process
-------------

* Clone git repository
* Build the Dockerfile in the root directory of the repository with the ```docker build``` command.
* Write a build result .json file out to /build


How to run
----------
```bash
    docker run --rm -i 
        -v /var/run/docker.sock:/var/run/docker.sock
        -v <local-build-results-folder>:/builds:rw 
        -v <path-to-ssh-keys>:/ssh
        --env TAG=<tag>
        --env REPO=<repository> 
        --env BUILD_ID=<buildId> 
        nodejs-build-agent:6.9.5
```

E.g.
```bash
    docker run --rm -i 
        -v /var/run/docker.sock:/var/run/docker.sock
        -v /home/user/build-results:/builds:rw 
        -v /home/user/.ssh:/ssh
        --env TAG=0.0.1
        --env REPO=https://github.com/somerepo.git
        --env BUILD_ID=1 
        nodejs-build-agent:6.9.5
```

Arguments
---------

*   ```<local-build-results-folder>``` Folder where the build result file is written to once the build has completed.
*   ```<path-to-ssh-keys>``` Optional. Folder containing ssh keys used to authenticate during ```git clone```.
*   ```<tag>``` This is the build tag that is passed through to ```docker build```.
*   ```<repository>``` The git repository to clone.
*   ```<buildId>``` An identifier for the instance of the build e.g. 123. This forms the filename of the build result file e.g. *build-123.json*.
 
 
Notes
-----

To automatically authenticate with a git repository using ssh, add a config file into the same folder as the ssh keys.

For example, to authenticate with bitbuket.org and automatically accept the hosts RSA key fingerprint, create the following file:- 

```config```
```bash
Host bitbucket.org
    Hostname 104.192.143.2
    StrictHostKeyChecking no
```

*IMPORTANT* This is a potential security issue as it opens you up to a man-in-the-middle type attack. An alternative would be to use ```known_hosts```.
