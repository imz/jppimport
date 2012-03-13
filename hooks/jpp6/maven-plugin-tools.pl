#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('maven-plugin-tools-2.4.3-alt-fresh-tidy-support.patch',STRIP=>0);
#    $jpp->get_section('install')->push_body(q!
#cat %buildroot/etc/maven/fragments/* | \
#sed -e 's,<groupId>org.apache.maven,<groupId>org.apache.maven.plugin-tools,' > \
#%buildroot/etc/maven/fragments/%name-hacked
#
#!);
};
__END__
