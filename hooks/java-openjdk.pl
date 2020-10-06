#!/usr/bin/perl -w

my $centos=0;
require 'set_jvm_preprocess.pl';
require 'java-openjdk-common.pl';
$__jre::dir='%{sdkdir}';
require 'java-openjdk-common-textrel.pl';
require 'java-openjdk-common-man.pl';
require 'java-openjdk-common-jobs-parallel.pl';

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    if ('rename') {
	$spec->get_section('package','devel')->push_body('Provides: java-devel = %EVR'."\n");
	$spec->get_section('package','headless')->push_body('Provides: java-headless = %EVR'."\n");
	$spec->get_section('package','')->push_body('Provides: java = %EVR'."\n");
    }
    # fix me; proper nss
    $spec->spec_apply_patch(PATCHFILE=>'java-10-openjdk.spec.no-nss.diff');
    $spec->spec_apply_patch(PATCHFILE=>'java-openjdk.spec.no-ecc-test.diff');
    $spec->get_section('files','headless')->map_body(sub{$_='#'.$_ if m!^\%\{_jvmdir\}/\%\{sdkdir\}/lib/libsunec.so!});
    #------------------------------------
    my $mainsec=$spec->main_section;

    # TODO: drop me!
    $mainsec->subst_body_if(qr'java-openjdk-devel','java-9-openjdk-devel',qr'^BuildRequires:');
    $spec->get_section('build')->subst_body_if(qr'java-\%\{majorver\}-openjdk','java-9-openjdk',qr'--with-boot-jdk');

    # priority 1 -> 2
    $mainsec->map_body(sub{if(/^\%global priority/){s,00000\%\{minorver\}1,00000%{minorver}2,}});

    # https://bugs.java.com/bugdatabase/view_bug.do?bug_id=JDK-8196218
    $spec->add_patch('java-10-openjdk-alt-link-fontmanager.patch',STRIP=>0);

    # https://bugs.openjdk.java.net/browse/JDK-8237879
    $spec->add_patch('java-9-openjdk-alt-JDK-8237879.patch',STRIP=>0);

    # https://bugzilla.altlinux.org/show_bug.cgi?id=27050
    $spec->add_patch('java-9-openjdk-alt-no-objcopy.patch',STRIP=>0);
    $mainsec->subst_body(qr'^\%global include_debug_build 1','%global include_debug_build 0');
    $mainsec->subst_body(qr'^\%global include_normal_build 0','%global include_normal_build 1');

    $spec->spec_apply_patch(PATCHFILE=>'java-10-openjdk-alt-bug-32463.spec.diff') if not $centos;

    # it does arch dependent :(
    $spec->get_section('package','javadoc')->exclude_body('BuildArch: noarch');

    if (not $centos) {
	#$spec->get_section('files','headless')->push_body(q!%exclude %{_jvmdir}/%{sdkdir}/lib/audio/default.sf2!."\n");
	#$spec->get_section('files','')->push_body(q!%{_jvmdir}/%{sdkdir}/lib/audio/default.sf2!."\n");
    }
};

__END__
