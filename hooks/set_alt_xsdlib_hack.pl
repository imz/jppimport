#!/usr/bin/perl -w

push @SPECHOOKS, 

sub  {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->subst_body(qr' xsdlib',
					'msv-xsdlib');
}
