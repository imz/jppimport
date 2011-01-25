#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
#    $jpp->get_section('package','')->subst(qr'','');
#    $jpp->get_section('package','')->subst_if(qr'','',qr'Requires:');
    $jpp->get_section('package','')->unshift_body('BuildRequires: maven2-plugin-compiler maven-surefire-maven-plugin maven2-plugin-jar maven2-plugin-install maven2-plugin-javadoc jmock maven-doxia-sitetools'."\n");
};

__END__
