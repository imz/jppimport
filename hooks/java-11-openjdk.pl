#!/usr/bin/perl -w

my $centos=1;
require 'set_jvm_preprocess.pl';
require 'java-openjdk-common.pl';
$__jre::dir='%{sdkdir}';

# https://bugzilla.redhat.com/show_bug.cgi?id=787513
#alternatives.prov: /usr/src/tmp/java-1.6.0-openjdk-buildroot/etc/alternatives/packages.d/java-1.6.0-openjdk-java: /usr/share/man/man1/policytool-java-1.6.0-openjdk.1.gz for /usr/share/man/man1/policytool.1.gz is in another subpackage

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    my $mainsec=$spec->main_section;

# TODO: current hack:
# 1) drop custom optflags? 
# 2) add
#sed -i -e 's, -m32, -m32 %optflags_shared -fpic -D_BLA_BLA_BLA1,' openjdk/hotspot/make/linux/makefiles/gcc.make
#    # fix textrels on %ix86
#    $spec->get_section('prep')->push_body(q!sed -i -e 's, -m32, -m32 %optflags_shared -fpic -D_BLA_BLA_BLA1,' openjdk/hotspot/make/linux/makefiles/gcc.make!."\n");

    # for %{__global_ldflags} -- might be dropped in the future
    $mainsec->unshift_body('BuildRequires(pre): rpm-macros-fedora-compat'."\n");

    # TODO: drop me!
    $mainsec->subst_body_if(qr'java-11-openjdk-devel','java-1.8.0-openjdk-devel',qr'^BuildRequires:');

    # 1core build (16core build is out of memory)
    # export NUM_PROC=%(/usr/bin/getconf _NPROCESSORS_ONLN 2> /dev/null || :)
    $spec->get_section('build')->subst_body_if(qr'^export\s+NUM_PROC=','#export NUM_PROC=','_NPROCESSORS_ONLN');

    # no debug build in 1.8.65
    $mainsec->subst_body(qr'^\%global include_debug_build 1','%global include_debug_build 0');

    # TODO:!!!
    # https://bugzilla.altlinux.org/show_bug.cgi?id=27050
    #$mainsec->unshift_body('%add_verify_elf_skiplist *.debuginfo'."\n");
    #$spec->get_section('prep')->push_body(q!sed -i -e 's,DEF_OBJCOPY=/usr/bin/objcopy,DEF_OBJCOPY=/usr/bin/NO-objcopy,' openjdk/hotspot/make/linux/makefiles/defs.make!."\n");

    $spec->get_section('package','javadoc')->push_body('# fc provides
Provides: java-javadoc = 1:1.11.0
');

    $mainsec->exclude_body(qr'^Obsoletes:\s+(?:java-1.7.0-openjdk)');

    # TODO rediff for 11
    # as-needed link order / better patch over patch system-libjpeg.patch ?
    #$spec->add_patch('java-1.8.0-openjdk-alt-link.patch',STRIP=>1);

    # desktop
    $spec->spec_apply_patch(PATCHFILE=>'java-1.8.0-openjdk-alt-bug-32463.spec.diff') if not $centos;

    # already 0
    #$mainsec->subst_body(qr'define runtests 1','define runtests 0');

    # unrecognized option; TODO: check the list
    #$spec->get_section('build')->subst_body(qr'./configure','./configure --with-openjdk-home=/usr/lib/jvm/java');

    # do we need it?
    $spec->get_section('install')->unshift_body('unset JAVA_HOME'."\n");

    #### Misterious bug:
    # java -version work with JAVA_HOME=/usr/lib/jvm/java-1.7.0
    # but does not work with JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk
    # both are alternatives, former one works, but later one somehow is broken :(
    $spec->get_section('build')->map_body(sub {s/(\d+)-openjdk/$1/ if m!JDK_TO_BUILD_WITH=/usr/lib/jvm/java-\d+-openjdk!});

};


__END__
