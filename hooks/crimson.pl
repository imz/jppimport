push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    &rename_package ($jpp, $alt, 'crimson', 'jakarta-crimson');
};

sub rename_package {
    my ($jpp, $alt, $oldname, $newname) = @_;
    for my $sect (@{$jpp->get_sections()}) {
	$sect->subst(qr'%{name}','%{oldname}');
	$sect->subst(qr'%name','%oldname');
	if ($sect->get_type() eq 'package') {
	    $sect->subst_if(qr'%{?oldname}?','%{name}',qr'^\s*Requires:\s*%{?oldname}?');
	}
    }
    $jpp->get_section('package','')->unshift_body('%define oldname '.$oldname."\n");
    $jpp->get_section('package','')->set_tag('Name',$newname);
    $jpp->get_section('prep')->subst(qr'%setup -q\n','%setup -q -n %{oldname}-%{version}'."\n");

}
