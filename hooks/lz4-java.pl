#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('install')->subst_body_if(qr'\%\{arm\}','%{arm} %{e2k}',qr'^\%ifnarch');
};

__END__
