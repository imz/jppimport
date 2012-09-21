#!/usr/bin/perl -w

require 'add_missingok_config.pl';
require 'set_bin_755.pl';

push @SPECHOOKS, 
 sub {
    my ($jpp, $alt) = @_;
    &add_missingok_config($jpp, '/etc/java/aspectj.conf','');
    #$jpp->add_patch('aspectj-ant_0_8_fix.diff',STRIP=>2);
    $jpp->get_section('package','')->subst_if('saxon(\s+[>=]+\s+[\d:\-\.]+)?','saxon6',qr'Requires:');
    $jpp->get_section('prep')->subst(qr'build-classpath saxon','build-classpath saxon6');

    # for 1.5.4. Deprecated?
    $jpp->get_section('package','')->unshift_body('BuildRequires: ant-apache-regexp ant-apache-xalan2'."\n");
    # ant 1.8
    $jpp->get_section('prep')->push_body(q!sed -i -e 's,<antcall,<antcall inheritRefs="true",g'  build/build-properties.xml!."\n");
    $jpp->get_section('build')->subst(qr'-Xmx512','-Xmx1024');
    $jpp->get_section('install')->subst(qr'\%{buildroot}\%{_libdir}/eclipse','%{buildroot}%{_datadir}/eclipse');
    $jpp->get_section('files','eclipse-plugins')->subst(qr'\%{_libdir}/eclipse','%{_datadir}/eclipse');
}
__END__
#    $jpp->get_section('package')->subst('saxon-scripts','saxon6-scripts');
#    $jpp->applied_block(
#    	"bin saxon6 hook",
#	sub {
#    $jpp->get_section('build')->subst('/usr/bin/saxon','/usr/bin/saxon6');
#    $jpp->get_section('prep')->subst('/usr/bin/saxon','/usr/bin/saxon6');
#    $jpp->get_section('build')->subst('saxon\s+-o','saxon6 -o');
#    $jpp->get_section('prep')->subst('saxon\s+-o','saxon6 -o');
#    });
