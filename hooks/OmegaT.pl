#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    # hack against sisyphus check - jar is arch dependent due to 
#%ifarch x86_64  # get rids the hardlink to hunspell
#sed -i -e "s|/usr/lib/libhunspell|/usr/lib64/libhunspell|g" src/org/omegat/util/OConsts.java
#%endif
    $jpp->get_section('install')->push_body('# hack to mark a package as an arch
mkdir -p %{buildroot}%{_jnidir}/
ln -s %_javadir/OmegaT.jar %{buildroot}%{_jnidir}/OmegaT.jar'."\n");
    $jpp->get_section('files','')->push_body('%_jnidir/*'."\n");
};

__END__
