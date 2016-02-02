#!/usr/bin/perl -w

require 'set_osgi.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;

    $jpp->main_section->exclude_body(qr'^(Provides|Obsoletes):\s+junit4');
    $jpp->main_section->push_body('
Provides: junit = 0:%{version}
Provides: junit4 = %{epoch}:%{version}-%{release}
Conflicts: junit4 < 1:4.11-alt3_1jpp7
Obsoletes: junit4 < 1:4.11-alt3_1jpp7
Obsoletes: junit-junit4 < 1:4.11-alt3_1jpp7
Obsoletes: junit-junit3 < 1:3.8.2-alt9_10jpp6
Conflicts: junit-junit4 < 1:4.11-alt3_1jpp7
Conflicts: junit-junit3 < 1:3.8.2-alt9_10jpp6
');

};

__END__
