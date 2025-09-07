## php fpm alpine container

Creating a new build with tag '8' without multi-arch support:

    $ docker build -t php-fpm-alpine:8.3 -f ./Dockerfile .
    $ docker tag php-fpm-alpine:8.3 metalmanufactures/php-fpm-alpine:8.3
    $ docker login 
    $ docker push metalmanufactures/php-fpm-alpine:8.3

Sometimes the base php image bakes in libraries in minor versions. For example the tokenizer library. You can run this to check that:

    $ docker run --rm php:8.3-fpm-alpine php -i | grep -i token

Creating a new build with tag '8.3' **with** multi-arch support:

    $ docker buildx build --platform linux/arm64,linux/amd64 -t metalmanufactures/php-fpm-alpine:8.3 --push .

If you see the error "multiple platforms feature is currently not supported for docker drive" above, run the following `$ docker buildx create --use` and then run `docker buildx ls` to make sure `linux/arm64,linux/amd64` is listed.

When upgrading in the future, you may need to check these:
* https://pecl.php.net/package-changelog.php?package=mailparse
* https://pecl.php.net/package-changelog.php?package=mcrypt
