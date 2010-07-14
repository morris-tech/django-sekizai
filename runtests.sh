#!/bin/bash
cd tests
if [ "`python -c 'import django; print django.get_version()' 2>/dev/null`" == "1.2.1" ]
  then
    cd testapp
    if which coverage &> /dev/null; then
        coverage run manage.py test testapp
        retcode=$?
        coverage xml
    else
        python manage.py test testapp
        retcode=$?
    fi
    cd ..
  else
    echo "setting up test environment (this might take a while)..."
    python bootstrap.py >/dev/null 2>&1
    ./bin/buildout >/dev/null 2>&1
    ./bin/coverage testapp/manage.py test testapp
    retcode=$?
fi
cd ..
exit $retcode