#!/bin/sh


# ----- Test if ant is around ------------------------------------------------
# and bail out if it does not with a message that it is required

if [ ! `which ant` ]; then
  echo "You must install Ant (http://jakarta.apache.org/ant)"
  echo "and add \$ANT_HOME/bin to your PATH variable"
  exit 1
fi


# set the current working dir as the PROJECT_HOME variable 
PROJECT_HOME=$PWD
# use the location of this script to infer $FORREST_HOME
FORREST_HOME=`dirname $0`/..

# set the ant file to use
ANTFILE=$FORREST_HOME/forrest.build.xml

# call ant.
ant -buildfile $ANTFILE -Dproject.home=$PROJECT_HOME -Dforrest.home=$FORREST_HOME -emacs $@ 
