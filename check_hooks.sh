#!/bin/sh -v

for i in hooks/*.pl; do perl -c $i; done 2>&1 | grep -v 'Name "main::SPECHOOKS" used only onc' | grep -v 'syntax OK' | grep -v 'Name "main::PREHOOKS" used only once'

