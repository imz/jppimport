#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    #$spec->add_patch('',STRIP=>1);
    my $src=$spec->add_source('plexus-resources-1.0-components.xml');
    $spec->get_section('prep')->push_body(q!
mkdir -p target/classes/META-INF/plexus
cp -p %{SOURCE!.$src.q!} target/classes/META-INF/plexus/components.xml
!."\n");
};

__END__
