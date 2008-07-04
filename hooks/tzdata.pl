push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('package','')->subst(q'Conflicts:','#Conflicts:');
    $jpp->get_section('package','')->subst(q'glibc-common\s*>=\s*\S+','glibc-timezones');
    # I don't need this package
    $jpp->del_section('files','');
};

1;
