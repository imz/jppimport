#!/usr/bin/perl -w

push @SPECHOOKS, sub  {
    my ($jpp, $alt) = @_;
    $jpp->get_section('description','poms')->push_body('%{summary}.
');
}
