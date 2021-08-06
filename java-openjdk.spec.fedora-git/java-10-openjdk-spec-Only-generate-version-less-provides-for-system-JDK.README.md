This script "documents" (and allows to reproduce the result)
how I backported a change (a "patch") from Fedora's RPM spec file for
java-11-openjdk package to Fedora's RPM spec file for java-10-openjdk.


The interesting patch for the java-openjdk spec file
----------------------------------------------------

The patch that interests us is the one that introduces
the `%is_system_jdk` switch in the spec file; to get the idea, see the patches
saved (with git-format-patch from Fedora's Git repo with the spec):

    java-openjdk-spec-0001-Only-generate-version-less-provides-for-system-JDK.patch
    java-openjdk-spec-0002-Only-generate-internal-provides-for-non-debug-system.patch

I will name the result (the backported patches) like this:

    java-10-openjdk-spec-0001-Only-generate-version-less-provides-for-system-JDK.patch
    java-10-openjdk-spec-0002-Only-generate-internal-provides-for-non-debug-system.patch

jppimport has rules to translate Fedora's src.rpm for java-openjdk
into an src.rpm for ALT. jppimport is already able to produce
java-11-openjdk and java-10-openjdk for ALT, so it already knows
how to handle a spec file with the `%is_system_jdk` switch
(in the case of java-11-openjdk). So, jppimport should apply the backported
patches to the spec file from Fedora's java-10-openjdk and produce
java-10-openjdk for ALT with the `%is_system_jdk` switch. (I don't know yet
how to modify the rules used by jppimport for the translation.)

Since java-10-openjdk in ALT is mainly used only to bootstrap java-11-openjdk,
the `%is_system_jdk` switch can be turned off from the beginning, so that
java-10-openjdk can't interfere in the set of packages being installed
in an ALT environment. This is especially important for p9 and other
branches, where java-11-openjdk is not the default system jdk
(the `%is_system_jdk` switch is turned off for it in p9 and other branches),
so, without this switch, java-10-openjdk would become the default system jdk
(e.g., in hasher) because of its high version number, and this is unwanted.


Fedora's Git repos with the java-openjdk spec file
--------------------------------------------------

Some Fedora's Git repos with specs:

    git remote add java-11-openjdk@Fedora https://src.fedoraproject.org/rpms/java-11-openjdk.git
    git remote add java-openjdk@Fedora https://src.fedoraproject.org/rpms/java-openjdk.git
    git remote add java-latest-openjdk@Fedora https://src.fedoraproject.org/rpms/java-latest-openjdk.git

`java-openjdk` is the interesting one; it was the source for the java-10-openjdk
builds in Fedora, and has the interesting patch, too, but in a commit made after
java-10-openjdk (i.e., for java-11-openjdk, so that we need to rebase it).

`java-openjdk` has been recently renamed to `java-latest-openjdk`.

`java-11-openjdk` is another repo, where I first found the interesting patch.
We shouldn't need it for doing the rebase of the patch, because then I found
it in the `java-openjdk` repo, too.


Finding the commit with the revision of the java-10-openjdk spec file
---------------------------------------------------------------------

Now, I have to find the commit in Fedora's Git repo to rebase this
interesting patch onto.  It's a commit with the revision of the
java-10-openjdk spec file used for ALT.

    [imz@team ~]$ git -C /srpms/j/java-10-openjdk.git/ show sisyphus:import.info |head
    EVR: 1:10.0.2.13-7.fc29
    Name: java-openjdk
    Version: 10.0.2.13
    Release: 7
    Epoch: 1
    srpm: /var/ftp/pub/Linux/fedora/linux/releases/29/Everything/source/tree/Packages/j/java-openjdk-10.0.2.13-7.fc29.src.rpm
    %changelog
    * Thu Aug 23 2018 Jiri Vanek <jvanek@redhat.com> - 1:10.0.3.13-6
    - dissabled accessibility, fixed provides for main package's debug variant
    - now buildrequires javapackages-filesystem as the  issue with macros should be fixed
    [imz@team ~]$

One can search either by the last changelog entry from `import.info`, or by
the name of the package built in Fedora (`java-openjdk-10.0.2.13-7.fc29`).

Let's follow the second way.

Follow the sequence of web pages, links:

* <https://src.fedoraproject.org/>, search for "java-openjdk" among
  packages; you get to:
* <https://src.fedoraproject.org/rpms/java-openjdk>, follow the
  [Builds Status](http://koji.fedoraproject.org/koji/search?type=package&match=glob&terms=java-openjdk)
  link; you get to:
* <https://koji.fedoraproject.org/koji/packageinfo?packageID=26700>,
  and find the link to the build "java-openjdk-10.0.2.13-7.fc29":
* <https://koji.fedoraproject.org/koji/buildinfo?buildID=1138863>,
  look at the Source or Extra fields in the info; there you see the
  commit ID:
* `git+https://src.fedoraproject.org/rpms/java-openjdk.git#dd33c3caf38dfadd6b52602b084d8c5f2e4f65bb`

So, if you've cloned
<https://src.fedoraproject.org/rpms/java-openjdk.git>, there you'll
find it:

    $ git -C java-openjdk/ --no-pager log -3 --reverse dd33c3caf38dfadd6b52602b084d8c5f2e4f65bb --oneline
    f2b05f1 - Rebuilt for https://fedoraproject.org/wiki/Fedora_29_Mass_Rebuild
    33daef2 updated to security jdk10+3.13 - deleted patch106 JDK-8193802-npe-jar-getVersionMap.patch - deleted patch400 JDK-8200556-aarch64-slowdebug-crash.patch - deleted patch104 JDK-8201509-s390-atomic_store.patch - deleted patch103 JDK-8201788-bootcycle-images-jobs.patch
    dd33c3c Sync from rawhide

Rebasing the patches
--------------------

```
cd java-openjdk/
git switch -C is_system_jdk dd33c3caf38dfadd6b52602b084d8c5f2e4f65bb
git am -3 ../java-openjdk-spec-0001-Only-generate-version-less-provides-for-system-JDK.patch
```

(I skip
`java-openjdk-spec-0002-Only-generate-internal-provides-for-non-debug-system.patch`.)
I resolved the conflicts (to the best of my understanding; with
git-mergeool) and saved the result with git-format-patch to:

    java-10-openjdk-spec-0001-Only-generate-version-less-provides-for-system-JDK.patch
