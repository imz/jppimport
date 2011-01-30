#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst_if('maven-plugin-modello','modello-maven-plugin',qr'Requires:');
};

1;
__END__
TODO:
36a37
> BuildRequires: jetty6-core maven2-default-skin
