#!/usr/bin/perl -w

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
    $jpp->add_patch('commons-jelly-1.0-alt-xml-unit-1.2-support.patch',STRIP=>1);
}
