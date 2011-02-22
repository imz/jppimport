#!/usr/bin/perl -w

#require 'set_clean_surefire23.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('install')->push_body(q!
cat %buildroot/etc/maven/fragments/* | \
sed -e 's,<groupId>org.apache.maven,<groupId>org.apache.maven.plugin-tools,' > \
%buildroot/etc/maven/fragments/%name-hacked

!);
};
__END__
