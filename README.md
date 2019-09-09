# swen331fuzzerCI
The CI configuration for the SWEN 331 fuzzer assignment.

# Running inside GitLab CI

This image was initially intended to run inside of GitLab's CI. Here's our config:


image: andymeneely/swen331fuzzer
before_script:
    # do not change any of the statements in this section
    - service apache2 start
    - mysql_install_db --user=mysql -ldata=/var/lib/mysql
    - service mysql start
    - /usr/bin/mysqladmin -u root password fuzzer
    - service mysql restart
    - /mysql-setup.sh
    # do not change any of the statements in this section
fuzzrunner:
  script:
    # here is where you can write your commands to run your fuzzer or any custom setup commands
    - echo "hello class"
    # need some example files for vectors and words? These are on the image
    - cat /words.txt
    - cat /vectors.txt
    # An example fuzzer command. Note the url is DIFFERENT than XAMPP example (no /dvwa).
    - ruby fuzzer.rb discover http://localhost/ --custom-auth=dvwa
		- ruby fuzzer.rb discover http://localhost/fuzzer-tests
  stage: test

# 
