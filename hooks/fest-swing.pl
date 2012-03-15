#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->subst(qr'export MAVEN_OPTS="','export MAVEN_OPTS="-Dproject.build.sourceEncoding=ISO-8859-1 ');
};

__END__
