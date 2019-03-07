sub rename_jar {
    my ($spec,, $oldname, $newname) = @_;
    $spec->applied_off();
    for my $sect ($spec->get_sections()) {
	if ($sect->get_type() eq 'files') {
	    $sect->subst_body_if(qr'\%\{?oldname\}?','%{name}',qr'_javadir');
	}
    }
    $spec->get_section('install')->push_body(q!
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
    $spec->applied_on();
}

1;
