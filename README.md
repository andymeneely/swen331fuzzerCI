# swen331fuzzerCI
The CI configuration for the SWEN 331 fuzzer assignment.

# Building Docker Image Locally

Edit the Dockerfile, and then run:

```
$ docker build . --tag beta1
```

To run that locally, use:

```
$ docker run --rm -it -p 80:80 beta1
```


# Running locally

This will pull the image and run it.

```
$ docker run --rm -it -p 80:80 andymeneely/swen331fuzzer
```

After that, go to http://localhost in your browser.

# Running inside GitLab CI

This image was initially intended to run inside of GitLab's CI. Here's our config:

```
image:
  name: andymeneely/swen331fuzzer # don't change this
  entrypoint: [""]  # don't change this
before_script:
  # don't change these either
  - chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
  - echo '[+] Starting mysql...'
  - service mysql start
  - echo '[+] Starting apache'
  - service apache2 start
fuzzrunner:
  script:
    # here is where you can write your commands to run your fuzzer or any custom setup commands
    - echo "hello class"
    # need some example files for vectors and words? These are on the image
    - cat /words.txt
    - cat /vectors.txt
    - cat /badchars.txt
    # An example fuzzer command. Note the url is DIFFERENT than XAMPP example (no /dvwa).
    - ruby fuzz.rb discover http://localhost/ --custom-auth=dvwa
    - ruby fuzz.rb discover http://127.0.0.1/fuzzer-tests
  stage: test
```

# Running locally

Have Docker on your machine? You can run the image like this:

```
$ docker run --rm -it -p 80:80 andymeneely/swen331fuzzer
```

Then go to your browser for localhost.

Sometimes Docker doesn't kill this image properly. Use `docker ps` to check if the image is still running. And `docker kill` to kill it if need be.

# fuzzer-tests

When testing against fuzzer-tests, here's what you should find...

During `fuzz discover`:

  * The main page `index.php` has two inputs, one via called `calzone` (discoverable via form) and another called `message` (discoverable via url parameter parsing).
  * There is a page called `valid.php`
  * There is a page called `timeout.php`
  * There is a page called `admin.php` not linked from anywhere, it has an input called `company` (discoverable via form OR url parsing)
  * There is a page called `sensitive.php` linked only from `admin.php`
  * There is NOT a page called "CioffisTheBest.html". That link is dead.
  * Your fuzzer should NOT go in an infinite loop.
  * Your fuzzer should NOT go `http://se.rit.edu`

During `fuzz test`:

  * `index.php`, input `calzone` lacks sanitization
  * `index.php`, input `message` lacks sanitization
  * `valid.php` has no inputs
  * `timeout.php` has no inputs, but it has a long delay
  * `admin.php`, input `company` lacks sanitization
  * `sensitive.php` has no inputs, but leaks sensitive data of 123-45-6789
  * `timeout.php` takes at least 2 seconds to load
