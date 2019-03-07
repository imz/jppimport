require 'set_osgi.pl';

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
};

__END__
    $spec->get_section('install')->push_body(q!
# compat symlink for eclipselink-2.3.2-alt1_1jpp7, jasperreports-4.0.2-alt1_3jpp7
mkdir -p $RPM_BUILD_ROOT%{_javadir}/hibernate
ln -s ../%{name}.jar $RPM_BUILD_ROOT%{_javadir}/hibernate/%{name}.jar
!."\n");
    #$spec->get_section('files')->push_body(q!!."\n");
