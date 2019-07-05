#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($spec,) = @_;
    # $manpage .1)-%{uniquesuffix}.1
    $spec->get_section('install')->map_body(sub{s,-\%\{uniquesuffix\}\.1,%{label}.1, if /manpage/});

    # warning (#100): non-identical /usr/share part
    # /usr/share/man/man1/jstatd-java-9-openjdk-9.0.4.11-6.ppc64le.1.gz
    foreach my $sec ($spec->get_sections) {
	next if $sec->get_type ne 'files';
	$sec->map_body(sub {s,-\%\{uniquesuffix\},%{label}, if /^\%\{?_man/ });
    }
};

__END__
