#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    $spec->add_patch('ht2html-2.0-alt-fix-whrandom.patch',STRIP=>1);
};

1;
