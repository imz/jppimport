# todo; build with java 1.5 !!!
#require 'set_target_14.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->unshift_body("BuildRequires: maven-scm maven2-default-skin\n");
};
