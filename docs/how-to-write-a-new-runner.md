# How to write a new runner

This document describes how to write a new runner when you are going to support a new tool.

## Tasks

- [Create a base image](#create-a-base-image)
- [Define a runner ID](#define-a-runner-id)
- [Create a runner image](#create-a-runner-image)
- [Write a processor](#write-a-processor)

### Create a base image

If it is not provided yet, create a Docker base image on [sider/devon_rex](https://github.com/sider/devon_rex) first.

A runner image is built based on a base image. We manage base images in [sider/devon_rex](https://github.com/sider/devon_rex) repository.
These images are prepared for each programming environment (e.g. Ruby, Java, PHP, and so on).

We have already provided many base images. Thus, you do not need to add a new base image in almost cases.
However, you need to make new one when you try to add a new programming language and environment.

### Define a runner ID

First, let's define an ID of the runner that you are going to support.
This ID will be used everywhere as a directory name, a image, etc.

Please follow the naming rules below:

- Use only lowercase letters (`a-z`) and underscores (`_`), e.g. `foolint` or `foo_lint`.
- Make it simple and clear.

### Create a runner image

Next, let's create a Docker image for the runner.

For example, if a runner ID is `foolint`, its `Dockerfile` location is `images/foolint/Dockerfile.erb`.
`images/foolint/Dockerfile` is generated automatically.

`.erb` is a file extension for [ERB](https://en.wikipedia.org/wiki/ERuby), that is a Ruby template engine.
See the official manual for more details about ERB.

In the `Dockerfile`, you will write the followings:

- Install the tool. (download, compile, and so on.)
- Install the tool's dependencies (libraries, plugins, and so on.) if needed.
- Setup the tool's default configuration file for Sider if needed.

### Write a processor
