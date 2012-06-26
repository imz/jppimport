#!/usr/bin/perl -w

require 'set_clean_surefire23.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('plexus-naming-migration-to-component-metadata.patch',STRIP=>0);
    $jpp->get_section('package','')->subst_body_if(qr'plexus-maven-plugin','plexus-containers-component-metadata',qr'Requires');
};

__END__
