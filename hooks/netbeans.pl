require 'add_missingok_config.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp, '/etc/%{name}.conf');
};
__END__
$jpp->main_section->push_body(q!
# harness symlink mislead autoreq :(
%add_findreq_skiplist /usr/share/netbeans/%version/harness
!);
    # hacks for 7.0.1-1 fc17
    foreach my $sec ($jpp->get_sections) {
	$sec->subst_body(qr'(?<!%)\%{nb_major_ver}','%{nb_ver_major}');
    }
    $jpp->get_section('package','')->unshift_body(q!%define nb_javadoc javadoc!."\n");


