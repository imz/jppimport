#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->push_body(q!Obsoletes:       jakarta-%{short_name} < 0:%{version}-%{release}!."\n");
};

__END__
