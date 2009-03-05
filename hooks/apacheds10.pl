#!/usr/bin/perl -w

#require 'add_missingok_config.pl';

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

#Пакет apacheds10-server-main версии 0:1.0.2-alt1_4jpp5 имеет неудовлетворенные зависимости:
#Требует: /etc/sysconfig/apacheds
    if ($jpp->get_section('package','')->match(qr'^Source4:\s+\%{name}.init')) {
	# hack; to be included in modified init script
	$jpp->get_section('prep')->unshift_body(q!subst 's,/etc/sysconfig/apacheds,/etc/sysconfig/%name,g' %{SOURCE4}!."\n");
    } else {
	die "fixme";
    }
};

__END__
