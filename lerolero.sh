#!/bin/bash
# Lero lero
# AUTHOR: Raul Libório, rauhmaru@opensuse.org
# O script acessa o lerolero.com e puxa a frase da homepage. E só.

curl -s http://www.lerolero.com | grep blockquote | sed 's/<[^>]*>//g'
