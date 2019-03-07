#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    # different noarches due to .qualifier in version (is replaced by timestamp)
    $spec->get_section('build')->subst_body(qr'pdebuild','pdebuild -a "-DforceContextQualifier=%{rlsdate}"');
};
