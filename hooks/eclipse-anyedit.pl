#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    # different noarches due to .qualifier in version (is replaced by timestamp)
    $spec->get_section('build')->subst(qr'pdebuild','pdebuild -a "-DforceContextQualifier=%{rlsdate}"');
};
