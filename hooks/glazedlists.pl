#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('prep')->subst_body(qr's#ECLIPSE_DIR#\%\{eclipse_dir\}#','s#ECLIPSE_DIR#%{_jnidir}#');
};

__END__
