#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    my $mainsec=$spec->main_section;
    $mainsec->push_body(q!BuildArch: noarch!."\n") if not $mainsec->match_body(qr'BuildArch');
};

__END__
