#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # hack around non-jpp mx4j
    map {$_->subst(qr'homedir','apphomedir')} @{$jpp->get_sections()};
};

1;
