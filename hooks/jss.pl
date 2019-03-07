#!/usr/bin/perl -w

push @SPECHOOKS, 
sub {
    my ($spec,) = @_;
    $spec->add_patch('jss-link-alt.patch',STRIP=>1);
    $spec->add_patch('jss-alt-sem-as-needed.patch',STRIP=>1);
    $spec->get_section('build')->subst_body(qr'\%if 0\%\{\?__isa_bits\} == 64','%ifarch x86_64 ppc64 ia64 s390x sparc64');

    $spec->get_section('build')->unshift_body_before(qr'The Makefile is not thread-safe',q@
# 3.0(t6), 3.5(SIS) kernels support
for i in 0 `seq 3 20`; do
cp -p mozilla/security/coreconf/Linux3.1.mk mozilla/security/coreconf/Linux3.$i.mk
sed -i -e 's;LINUX3_1;LINUX3_'$i';' mozilla/security/coreconf/Linux3.$i.mk
done

fix_kversion(){
set -- $(uname -r | cut -d. -f 1-2 --output-delimiter=" ")
local KMAJ=$1; shift
local KMIN=$1; shift
if [ ! -s "mozilla/security/coreconf/Linux$KMAJ.$KMIN.mk" ]; then
  cp -p mozilla/security/coreconf/Linux3.1.mk mozilla/security/coreconf/Linux"$KMAJ.$KMIN".mk
  sed -i -e "s;LINUX3_1;LINUX$KMAJ_$KMIN;" mozilla/security/coreconf/Linux"$KMAJ.$KMIN".mk
fi
}
fix_kversion

@);
    # compat symlink
    $spec->get_section('install')->push_body(q!mkdir -p %buildroot%_javadir/
ln -s %_jnidir/jss4.jar %buildroot%_javadir/jss4.jar!."\n");
    $spec->get_section('files')->push_body(q!%_javadir/jss4.jar!."\n");

};

__END__
