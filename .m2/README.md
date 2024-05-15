# Maven

Here are my settings.xml and toolchains.xml files.  They are versioned in the
form:

    [settings|toolchains]_[hostname].xml

The expectation is that the settings.xml and toolchains.xml files will be
symlinks to one of the host-specific files.  For example, on the 5NHMND2-PC
host, the files would be linked like this:

* `settings.xml` → `settings@5NHMND2-PC.xml`
* `toolchains.xml` → `toolchains@5NHMND2-PC.xml`

The reason for doing this is because there's also a `settings-security.xml`
file, which holds the host-specific secret encryption key that should not be
shared.

See: <https://maven.apache.org/guides/mini/guide-encryption.html>
