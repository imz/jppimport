#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body('%filter_from_requires /.etc.java.jing-trang.conf/d'."\n");
    $jpp->get_section('files','jing')->subst_body('^\%doc jing-','%doc --no-dereference jing-');
};

__END__