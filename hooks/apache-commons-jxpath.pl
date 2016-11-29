#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
};

__END__
    $spec->get_section('package','')->unshift_body('BuildRequires: tomcat6-jsp-2.1-api'."\n");
