#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->main_section->push_body(q!Conflicts: geronimo-specs < 0:1.2-alt9_16jpp6!."\n");
};

__END__
