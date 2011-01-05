#!/usr/bin/perl -w

require 'set_fix_repolib_project.pl';

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # it is like we do not need it
    $jpp->del_section('triggerpostun','','commons-beanutils < 1.7');
}

__END__
