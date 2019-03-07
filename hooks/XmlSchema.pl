#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('package','')->push_body('
Provides: ws-commons-%name = 0:%version-%release
Conflicts:  ws-commons-%name <= 0:1.4.7-alt3_7jpp7
Obsoletes:  ws-commons-%name <= 0:1.4.7-alt3_7jpp7
'."\n");
};

__END__
