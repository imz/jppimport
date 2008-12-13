push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->push_body(q!
# macos proxy detection code :(
#+ Requires: /usr/bin/grep
#+ Requires: /usr/sbin/scutil
%add_findreq_skiplist /usr/share/netbeans/platform8/lib/nbexec
!);
  
};

