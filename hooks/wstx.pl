#!/usr/bin/perl -w

$spechook = sub {
    my ($jpp, $alt) = @_;
	$jpp->get_section('package','')->unshift_body('BuildRequires: bcel ant-bcel'."\n");
}
