#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('retroweaver-2.0.2-alt-no-svn.patch',STRIP=>1);
    $jpp->get_section('package')->unshift_body('ExclusiveArch: %ix86'."\n");
    $jpp->get_section('package')->unshift_body('BuildRequires: jaxen jakarta-oro'."\n");
    $jpp->get_section('prep')->push_body('ln -sf $(build-classpath jaxen) lib/'."\n");
    $jpp->get_section('build')->unshift_body('export CLASSPATH=$(build-classpath jaxen oro)'."\n");
#    $jpp->get_section('build')->unshift_body_after('-Dmaven.test.skip=true \\', qr'^maven');
};

__END__
# and commented out ibm/bea
2c2
< #BuildRequires: jpackage-generic-compat
---
> BuildRequires: jpackage-generic-compat
3a4
> BuildRequires: jaxen jakarta-oro
46a48
> Patch1: retroweaver-2.0.2-alt-no-svn.patch
109a112
> ln -sf $(build-classpath jaxen) lib/
112a116
> %patch1 -p1 -b .sav1
116a121
> export CLASSPATH=$(build-classpath jaxen oro)
118a124
>     -DbuildNumber=%release \
