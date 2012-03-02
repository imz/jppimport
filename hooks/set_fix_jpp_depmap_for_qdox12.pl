#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    #$jpp->source_apply_patch('',STRIP=>1);
    $jpp->get_section('package','')->subst_if(qr'qdox161','qdox',qr'Requires:');
    $jpp->get_section('prep')->push_body(q!
sed -i -e s,qdox161,qdox,g ../../SOURCES/*-jpp-depmap.xml
!."\n");
};

__END__
