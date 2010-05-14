#!/usr/bin/perl -w

#require 'set_target_14.pl';

# other way is
push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # is it not deprecated?
    $jpp->get_section('prep')->push_body('%__subst \'s,avalon-framework-[0-9\.]\+,avalon-framework-*,\' etc/common-xdoclet.xml'."\n");

    # jpp6 skip
    #$jpp->get_section('install')->subst('^cp -pr doc', 'cp -pr --no-dereference doc');

    # common with jackorb

#    $jpp->get_section('package')->push_body('AutoReq: auto,noshell'."\n");
    $jpp->get_section('package','',)->push_body('%add_findreq_skiplist /usr/share/%{name}-*'."\n");
#    $jpp->get_section('build')->unshift_body('export ANT_OPTS=-mx80m'."\n");
    $jpp->get_section('build')->unshift_body('export ANT_OPTS=" -Xmx256m "'."\n");
    $jpp->get_section('install')->push_body(q!
pushd $RPM_BUILD_ROOT/usr/share/%name-%version/bin
chmod 644 *.conf
for i in *.template; do
    cat $i | sed -e 's,@@@JACORB_HOME@@@,/usr/share/%name-%version/bin,' > `echo $i | sed -e 's,.template$,,'`
done
popd
!);
}
