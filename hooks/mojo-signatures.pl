#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    #$spec->add_patch('',STRIP=>1);
    $spec->copy_to_sources('0001-pom.xml-files.patch');
    $spec->get_section('package','')->unshift_body('BuildRequires: java-1.5.0-devel'."\n");
};

__END__
