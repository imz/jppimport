#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    # bad elf symbols - native broadcom
    $spec->add_patch('jogl2-disable-build-native-broadcom.patch',STRIP=>2);

    # if remove. check scilab! it depends on jogl2
    $spec->get_section('install')->subst_body(qr'_jnidir','_javadir');
};

__END__
#    $spec->get_section('package','')->push_body('BuildArch: noarch'."\n");
#    $spec->get_section('install')->exclude_body(qr'^install .*build/lib/\*\.so');
#    $spec->get_section('files','')->exclude_body('_libdir');
