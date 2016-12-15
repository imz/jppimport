#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->add_patch('protostream-1.0.0.Alpha7-alt-protoc-c.patch',STRIP=>1);
    $spec->get_section('package','')->unshift_body('BuildRequires: protobuf-c-compiler'."\n");
    $spec->get_section('package','')->push_body('BuildArch: noarch'."\n");
};

__END__
