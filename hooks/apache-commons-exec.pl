#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package')->unshift_body('BuildRequires: /bin/ping'."\n");
}

__END__
