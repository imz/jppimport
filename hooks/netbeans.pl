require 'add_missingok_config.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp, '/etc/%{name}.conf');
    $jpp->get_section('package','')->push_body(q!
# harness symlink mislead autoreq :(
%add_findreq_skiplist /usr/share/netbeans/%version/harness
!);
#    $jpp->get_section('package','')->subst_if('lucene', 'lucene2', qr'Requires:');
#    $jpp->get_section('build')->subst(qr'lucene.jar','lucene2.jar');
#    $jpp->get_section('install')->subst(qr'lucene.jar','lucene2.jar');
  
};

