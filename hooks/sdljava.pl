#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->add_patch('sdljava-0.9.1-alt-ruby19.patch',STRIP=>1);
    $jpp->get_section('package','')->unshift_body('BuildRequires: ruby-stdlibs'."\n");
    #$jpp->get_section('prep')->push_body(q!!."\n");
};

__END__
