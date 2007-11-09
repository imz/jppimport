#!/usr/bin/perl -w

require 'set_fix_jakarta_commons_cli.pl';

push @SPECHOOKS, 
sub  {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: jline'."\n");
    my $srcnum=$jpp->add_source('ant-SNAPSHOT-20071102.tar');
    $jpp->get_section('prep')->push_body(
'pushd jelly-tags
rm -rf ant
tar xf %{SOURCE'.$srcnum.'}
popd
');
}
