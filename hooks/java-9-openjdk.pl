#!/usr/bin/perl -w

# TODO: https://bugs.java.com/bugdatabase/view_bug.do?bug_id=JDK-8196218

my $centos=0;
require 'set_jvm_preprocess.pl';
require 'java-openjdk-common.pl';
$__jre::dir='%{sdkdir}';
require 'java-openjdk-common-textrel.pl';
#require 'java-openjdk-common-jobs-parallel.pl';

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    $spec->spec_apply_patch(PATCHFILE=>'java-9-openjdk.spec.no-nss.diff');
    my $mainsec=$spec->main_section;

    # TODO: drop me!
    $mainsec->subst_body_if(qr'java-9-openjdk-devel','java-1.8.0-openjdk-devel',qr'^BuildRequires:');

    $spec->add_patch('java-9-openjdk-alt-link-fontmanager.patch',STRIP=>0);

    # https://bugzilla.altlinux.org/show_bug.cgi?id=27050
    $spec->add_patch('java-9-openjdk-alt-no-objcopy.patch',STRIP=>0);
    $mainsec->subst_body(qr'^\%global include_debug_build 1','%global include_debug_build 0');

    $spec->spec_apply_patch(PATCHFILE=>'java-1.8.0-openjdk-alt-bug-32463.spec.diff') if not $centos;

#unpackaged directory: /usr/lib/jvm/java-9-openjdk-9.0.4.11-6.x86_64/lib/client
#sisyphus_check: check-subdirs ERROR: subdirectories packaging violation
#%ghost %{_jvmdir}/%{sdkdir}/lib/client/

};


__END__

    # do we need it?
    $spec->get_section('install')->unshift_body('unset JAVA_HOME'."\n");
