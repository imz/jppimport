#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: jetty6-servlet-2.5-api'."\n");
    $jpp->get_section('prep')->push_body(q!
sed -i 's,<slf4j.version>1.5.6</slf4j.version>,<slf4j.version>%{get_version slf4j}</slf4j.version>,' pom.xml
!);


};

__END__
