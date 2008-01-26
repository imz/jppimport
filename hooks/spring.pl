#!/usr/bin/perl -w

#jpp5.0

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('BuildRequires: jboss4-common qdox'."\n");
    $jpp->get_section('package','')->unshift_body('BuildRequires: velocity-tools12'."\n");
    $jpp->get_section('build')->unshift_body(q!
export CLASSPATH=$(build-classpath ant-launcher ant/ant-junit junit xjavadoc com
mons-collections commons-attributes-compiler qdox velocity-tools)
!);
};
