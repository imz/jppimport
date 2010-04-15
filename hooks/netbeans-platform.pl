push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body(q!
# macos proxy detection code :(
#+ Requires: /usr/bin/grep
#+ Requires: /usr/sbin/scutil
%add_findreq_skiplist /usr/share/netbeans/platform*/lib/nbexec
%add_findreq_skiplist /usr/share/netbeans/platform11/lib/nbexec
!);

#    $jpp->get_section('package','')->subst(qr'Obsoletes: netbeans-platform8 < 6.5','#Obsoletes: netbeans-platform8 < 6.5');
#    $jpp->get_section('package','')->subst(qr'Provides:  netbeans-platform8 < 6.5','#Provides:  netbeans-platform8 < 6.5');

#    $jpp->get_section('files','%{nb_harness}')->subst(qr'\%{nb_harness_dir}/suite.xml.orig','#%{nb_harness_dir}/suite.xml.orig');
  
};

