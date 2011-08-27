#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # for jpp 5.0
    $jpp->get_section('install')->push_body(q!
# fedora compatibility
pushd %buildroot%_javadir
ln -s freemarker-%version.jar freemarker-2.3.jar
popd
!);

    # useful anyway :) RH compatibility.
    # compat mapping 
    $jpp->get_section('install')->unshift_body_after('add_to_maven_depmap',
	'# fedora compatibility
%add_to_maven_depmap org.freemarker %{name} %{version} JPP %{name}
');


};

1;
__END__
