#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    $jpp->applied_block(
	"/var/name to /var/lib/name hook",
	sub {
	    map {
		$_->subst(qr'\%{_var}/\%{name}','/var/lib/%{name}');
	    } $jpp->get_sections();
	}
	);

#%pre server-main # not a system account!
    $jpp->get_section('pre','server-main')->subst(qr'groupadd', 'groupadd -r');
    $jpp->get_section('pre','server-main')->subst(qr'useradd', 'useradd -r');

#Пакет apacheds10-server-main версии 0:1.0.2-alt1_4jpp5 имеет неудовлетворенные зависимости:
#Требует: /etc/sysconfig/apacheds
    $jpp->copy_to_sources('apacheds10.init');
#    changes applied to apacheds10.init:
##    if ($jpp->get_section('package','')->match(qr'^Source4:\s+\%{name}.init')) {
##	# hack; to be included in modified init script
##	$jpp->get_section('prep')->unshift_body(q!subst 's,/etc/sysconfig/apacheds,/etc/sysconfig/%name,g' %{SOURCE4}!."\n");
##    }

    # bcprov is JVM-specific: should not be linked in post
#<13>Mar 14 20:01:53 rpmi: apacheds10-server-main-0:1.0.2-alt2_4jpp5 installed
#/usr/bin/build-jar-repository: error: Could not find bcprov Java extension for this JVM
#/usr/bin/build-jar-repository: error: Some specified jars were not found for this jvm
#error: execution of %post scriptlet from apacheds10-server-main-1.0.2-alt2_4jpp5 failed, exit status 7
    $jpp->get_section('post','server-main')->exclude(qr'bcprov');

};

__END__
