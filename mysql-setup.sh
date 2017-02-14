#!/bin/bash
mysql -uroot -pfuzzer -e "CREATE DATABASE dvwa"
mysql -uroot -pfuzzer dvwa < /dvwaDBsetup.sql
