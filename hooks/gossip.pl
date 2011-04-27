#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->rename_package('sonatype-gossip');

    # TODO: integrate in rename
    # %{_mavendepmapfragdir}/%{oldname}
    $jpp->get_section('files','')->subst_if(qr'oldname','name',qr'_mavendepmapfragdir');
};
