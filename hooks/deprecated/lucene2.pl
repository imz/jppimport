require 'set_rename_package.pl';
require 'set_rename_jar.pl';
require 'set_without_gcj.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    &rename_package ($jpp, $alt, 'lucene', 'lucene2');
    &rename_jar ($jpp, $alt, 'lucene', 'lucene2');
    $jpp->get_section('package','')->push_body('Provides: lucene22 = %epoch:%version-%release'."\n");
    $jpp->get_section('install')->push_body(q!
pushd $RPM_BUILD_ROOT%{_javadir}
ln -s lucene2.jar lucene22.jar
popd
!);
    $jpp->get_section('files','')->push_body('%_javadir/lucene22.jar'."\n");
    
};

