#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('package','')->push_body('
Provides: ws-commons-%name = 0:%version-%release
Conflicts:  ws-commons-%name <= 0:3.0.1-alt2_6jpp7
Obsoletes:  ws-commons-%name <= 0:3.0.1-alt2_6jpp7
'."\n");
};

__END__
