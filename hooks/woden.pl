#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->get_section('package','')->push_body('
Provides: ws-commons-%name = %version-%release
Conflicts:  ws-commons-%name <= 1.0-alt3_0.5.M9jpp7
Obsoletes:  ws-commons-%name <= 1.0-alt3_0.5.M9jpp7
'."\n");
};

__END__
