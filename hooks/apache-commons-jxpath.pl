#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
};

__END__
    $jpp->get_section('package','')->unshift_body('BuildRequires: tomcat6-jsp-2.1-api'."\n");
