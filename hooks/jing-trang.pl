#!/usr/bin/perl -w
require 'set_skip_usr_bin_run.pl';

push @SPECHOOKS, 
sub {
    my ($spec, $parent) = @_;
    $spec->get_section('package','')->unshift_body('%filter_from_requires /.etc.java.jing-trang.conf/d'."\n");
    $spec->get_section('files','-n jing')->subst_body('^\%doc jing-','%doc --no-dereference jing-');
};

__END__
