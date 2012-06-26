#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('fusesource-pom-1.8-migration-to-component-metadata.patch',STRIP=>0);
    $jpp->get_section('package','')->subst_body_if(qr'plexus-maven-plugin','plexus-containers-component-metadata',qr'Requires:');
};

__END__
