#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    #$spec->add_patch('',STRIP=>1);
    $spec->get_section('install')->subst_body(qr'%add_maven_depmap\s+JPP-\%{name}.pom','%add_maven_depmap -a "%{name}:%{name}" JPP-%{name}.pom');
    $spec->get_section('package','')->unshift_body('Requires: fusesource-pom'."\n");
};

__END__
