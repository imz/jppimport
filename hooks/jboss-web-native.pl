#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('files','devel')->exclude_body(qr'\%{_libdir}/libjbnative-1\.\*a');
};

__END__
