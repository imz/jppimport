#!/usr/bin/perl -w

# TODO: https://bugs.java.com/bugdatabase/view_bug.do?bug_id=JDK-8196218

my $centos=0;
require 'set_jvm_preprocess.pl';
require 'java-openjdk-common.pl';
$__jre::dir='%{sdkdir}';
require 'java-openjdk-common-textrel.pl';
require 'java-openjdk-common-jobs-parallel.pl';

# https://bugzilla.redhat.com/show_bug.cgi?id=787513
#alternatives.prov: /usr/src/tmp/java-1.6.0-openjdk-buildroot/etc/alternatives/packages.d/java-1.6.0-openjdk-java: /usr/share/man/man1/policytool-java-1.6.0-openjdk.1.gz for /usr/share/man/man1/policytool.1.gz is in another subpackage

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    my $mainsec=$spec->main_section;

    # for %{__global_ldflags} -- might be dropped in the future
    $mainsec->unshift_body('BuildRequires(pre): rpm-macros-fedora-compat'."\n");

    # TODO: drop me!
    $mainsec->subst_body_if(qr'java-9-openjdk-devel','java-1.8.0-openjdk-devel',qr'^BuildRequires:');

    # no debug build in 1.8.65
    $mainsec->subst_body(qr'^\%global include_debug_build 1','%global include_debug_build 0');

    # https://bugzilla.altlinux.org/show_bug.cgi?id=27050
    #$mainsec->unshift_body('%add_verify_elf_skiplist *.debuginfo'."\n");
    #$spec->get_section('prep')->push_body(q!sed -i -e 's,DEF_OBJCOPY=/usr/bin/objcopy,DEF_OBJCOPY=/usr/bin/NO-objcopy,' openjdk/hotspot/make/linux/makefiles/defs.make!."\n");
    # see java 9 make/common/NativeCompilation.gmk

    $spec->spec_apply_patch(PATCHFILE=>'java-1.8.0-openjdk-alt-bug-32463.spec.diff') if not $centos;

    # do we need it?
    $spec->get_section('install')->unshift_body('unset JAVA_HOME'."\n");

    #### Misterious bug:
    # java -version work with JAVA_HOME=/usr/lib/jvm/java-1.7.0
    # but does not work with JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk
    # both are alternatives, former one works, but later one somehow is broken :(
    $spec->get_section('build')->subst_body_if(qr/\.0-openjdk/,'.0',qr!JDK_TO_BUILD_WITH=/usr/lib/jvm/java-1.[789].0-openjdk!);

};


__END__
