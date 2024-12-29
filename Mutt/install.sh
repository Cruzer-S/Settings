#!/bin/bash
BASEDIR=$(dirname "$0")

mkdir -p ~/.mutt/

cp $BASEDIR/muttrc									~/.muttrc
cp $BASEDIR/mailcap									~/.mutt/
cp $BASEDIR/mutt-colors-solarized-dark-16.muttrc	~/.mutt/
cp $BASEDIR/mutt-patch-highlighting.muttrc			~/.mutt/
