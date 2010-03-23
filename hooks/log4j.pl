require 'set_target_14.pl';
require 'set_manual_no_dereference.pl';
require 'add_missingok_config.pl';

push @SPECHOOKS, 
sub {
    my ($jpp, $alt) = @_;
    $jpp->get_section('build')->subst(qr'jaxp.jaxp.jar.jar', 'jaxp.jaxp.jar');
    &add_missingok_config($jpp,'/etc/chainsaw.conf');
}
__END__


__DEPRECATED__
    # fixed missing org.apache.log4j.jmx

    if (1) {
	# either using the original jmx
	$jpp->get_section('package','')->push_body(q'BuildRequires: jmx
');
	$jpp->get_section('build')->subst(qr'build-classpath mx4j/mx4j-tools', 'build-classpath jmxtools');
	$jpp->get_section('build')->subst(qr'build-classpath mx4j/mx4j', 'build-classpath jmxri');
    } else {
	# or using mx4j (does not work)
	$jpp->get_section('prep')->subst(qr'#%%patch2', '%patch2');
	$jpp->get_section('prep')->push_body(q'
#subst s,com.sun.jdmk.comm.HtmlAdaptorServer,mx4j.tools.adaptor.AdaptorServerSocketFactory,g src/java/org/apache/log4j/jmx/Agent.java
#subst s,HtmlAdaptorServer,AdaptorServerSocketFactory,g src/java/org/apache/log4j/jmx/Agent.java
');
    }
