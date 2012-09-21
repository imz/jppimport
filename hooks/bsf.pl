#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # jython :(
    $jpp->get_section('package','',)->push_body('%add_findreq_skiplist /usr/share/bsf-*'."\n");
    #$jpp->get_section('package','demo',)->push_body('AutoReq: yes,nopython'."\n");
};
