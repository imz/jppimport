#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->push_body('
# hack to help match manuals on both arches;
# seems to be a bug in manual package to REPORT
rm -rf dist/docs/junit
');
}
