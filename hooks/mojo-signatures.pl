#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    #$jpp->add_patch('',STRIP=>1);
    $jpp->copy_to_sources('0001-pom.xml-files.patch');
    $jpp->get_section('package','')->unshift_body('BuildRequires: java-devel-1.5.0'."\n");
};

__END__
