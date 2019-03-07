#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('install')->subst_body_if(qr'macros.jruby','macros-jruby',qr'_rpmmacrosdir');
    $spec->get_section('files','devel')->subst_body_if(qr'macros.jruby','macros-jruby',qr'_rpmmacrosdir');
    $spec->get_section('package','')->unshift_body('%filter_from_requires /.usr.lib.*jffi/d'."\n");
};

__END__
