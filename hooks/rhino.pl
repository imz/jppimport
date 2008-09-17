#!/usr/bin/perl -w

push @SPECHOOKS, 
\&fix_etc_rhino_conf;

sub fix_etc_rhino_conf {
    my ($jpp, $alt) = @_;
    # for /etc/rhino.conf (todo)
    $jpp->get_section('package','')->unshift_body('AutoReq: yes, noshell'."\n");
}

1;
