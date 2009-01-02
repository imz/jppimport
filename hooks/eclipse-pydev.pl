#!/usr/bin/perl -w

push @SPECHOOKS, sub {
    my ($jpp, $alt) = @_;
    # altbug#13596
    $jpp->get_section('package','')->push_body('
# due to python2.4(java), python2.4(org)
%add_findreq_skiplist /usr/share/eclipse/plugins/org.python.pydev.jython_*/*/*
%add_findreq_skiplist /usr/share/eclipse/plugins/org.python.pydev.debug_*/*/*
%add_findreq_skiplist /usr/share/eclipse/plugins/org.python.pydev_*/*/*
%add_findreq_skiplist /usr/share/eclipse/dropins/pydev/eclipse/plugins/org.python.pydev.jython_*/*/*
%add_findreq_skiplist /usr/share/eclipse/dropins/pydev/eclipse/plugins/org.python.pydev.debug_*/*/*
%add_findreq_skiplist /usr/share/eclipse/dropins/pydev/eclipse/plugins/org.python.pydev_*/*/*
');
};
