#!/bin/bash

mp3wrap "result.mp3" `find . -iname \*mp3| sort|xargs` 2>> script-err.log
