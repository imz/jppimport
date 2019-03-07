#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($spec,) = @_;
    # bug to report
    $spec->get_section('description','')->subst_body(qr'obsfuscators','obfuscators');
};

