#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('install')->push_body('# hack for maven 304 to find jar
mkdir -p %{buildroot}%{_javadir}/
ln -s %_jnidir/jffi.jar %{buildroot}%{_javadir}/jffi.jar'."\n");
    $jpp->get_section('files','')->push_body('%_javadir/jffi.jar'."\n");
};

__END__
