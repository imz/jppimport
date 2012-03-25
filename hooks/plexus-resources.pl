#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    #$jpp->add_patch('',STRIP=>1);
    my $src=$jpp->add_source('plexus-resources-1.0-components.xml');
    $jpp->get_section('prep')->push_body(q!
mkdir -p target/classes/META-INF/plexus
cp -p %{SOURCE!.$src.q!} target/classes/META-INF/plexus/components.xml
!."\n");
};

__END__
