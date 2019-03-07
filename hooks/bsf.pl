#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    # jython :(
    $spec->get_section('package','',)->push_body('%add_findreq_skiplist /usr/share/bsf-*'."\n");
    #$spec->get_section('package','demo',)->push_body('AutoReq: yes,nopython'."\n");
};
