#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # different noarches due to .qualifier in version (is replaced by timestamp)
    $jpp->get_section('build')->subst(qr'pdebuild','pdebuild -a "-DforceContextQualifier=%{rlsdate}"');
};
