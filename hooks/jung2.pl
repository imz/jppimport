#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
#    $jpp->get_section('package','')->subst(qr'','');
#    $jpp->get_section('package','')->subst_if(qr'','',qr'Requires:');
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven2-plugin-resources maven2-plugin-source maven2-plugin-jar maven2-plugin-dependency maven2-plugin-javadoc java-1.6.0-openjdk-devel'."\n");
#  maven-shared-archiver
};

__END__
