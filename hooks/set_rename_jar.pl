sub rename_jar {
    my ($jpp, $alt, $oldname, $newname) = @_;
    $jpp->applied_off();
    for my $sect ($jpp->get_sections()) {
	if ($sect->get_type() eq 'files') {
	    $sect->subst_if(qr'%{?oldname}?','%{name}',qr'_javadir');
	}
    }
    $jpp->get_section('install')->push_body(q!
pushd $RPM_BUILD_ROOT%{_javadir}
rename !."$oldname $newname".q! `find . -name '!.$oldname.q!*' -type d`
for i in `find . -name '!.$oldname.q!*' -type f`; do
    pushd `dirname $i`
        rename !."$oldname $newname".q! `basename $i`
    popd
done
for i in `find . -name '!.$oldname.q!' -type l`; do
    oldval=`readlink $i`
    newval=`echo $oldval | sed -e 's/!."$oldname/$newname".q!/'`
    oldname=`basename $i`
    newname=`echo $oldname | sed -e 's/!."$oldname/$newname".q!/'`
    rm $i
    ln -s "$newval" `dirname $i`/"$newname"
done
popd
!);
    $jpp->applied_on();
}

1;
