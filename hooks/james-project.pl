#!/usr/bin/perl -w

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','-n james-server-root')->subst_if(qr'parent_version','project_version',qr'^Requires:');
#    $jpp->get_section('build')->subst(qr'javadoc:aggregate','javadoc:javadoc');
};

