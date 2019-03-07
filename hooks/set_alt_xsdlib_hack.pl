#!/usr/bin/perl -w

push @SPECHOOKS, 

sub  {
    my ($spec,) = @_;
    $spec->get_section('package','')->subst_body(qr' xsdlib',
					'msv-xsdlib');
}
