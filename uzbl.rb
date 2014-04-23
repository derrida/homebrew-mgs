require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Uzbl < Formula
  homepage ''
  url 'https://github.com/Dieterbe/uzbl.git'
  version 'git'
  sha1 ''

  # depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'glib' => :build
  depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on 'glib-networking'
  depends_on 'gsettings-desktop-schemas'
  depends_on 'libsoup'
  depends_on 'gtk+'
  depends_on 'gtk+3'
  depends_on 'webkit-gtk3'
  depends_on 'python3'
  depends_on 'curl-ca-bundle'

  patch :DATA

  def install
    # ENV.j1  # if your formula's build system can't parallelize
    #system "./configure", "--disable-debug",
        #"--disable-dependency-tracking",
    #                          "--prefix=#{prefix}"
    # system "cmake", ".", *std_cmake_args
    system "make all"
    system "make install"
    system "make install-example-data"
  end
end
__END__
diff --git a/Makefile b/Makefile
index ba74e57..c66691a 100644
--- a/Makefile
+++ b/Makefile
@@ -5,7 +5,7 @@ include $(wildcard local.mk)
 # packagers, set DESTDIR to your "package directory" and PREFIX to the prefix you want to have on the end-user system
 # end-users who build from source: don't care about DESTDIR, update PREFIX if you want to
 # RUN_PREFIX : what the prefix is when the software is run. usually the same as PREFIX
-PREFIX     ?= /usr/local
+PREFIX     ?= /usr/local/Cellar/uzbl/git
 INSTALLDIR ?= $(DESTDIR)$(PREFIX)
 DOCDIR     ?= $(INSTALLDIR)/share/uzbl/docs
 RUN_PREFIX ?= $(PREFIX)
@@ -13,7 +13,7 @@ RUN_PREFIX ?= $(PREFIX)
 ENABLE_WEBKIT2 ?= no
 ENABLE_GTK3    ?= auto
 
-PYTHON=python3
+PYTHON=/usr/local/bin/python3
 PYTHONV=$(shell $(PYTHON) --version | sed -n /[0-9].[0-9]/p)
 COVERAGE=$(shell which coverage)
 
@@ -202,11 +202,11 @@ install-uzbl-tabbed: install-dirs
 
 # you probably only want to do this manually when testing and/or to the sandbox. not meant for distributors
 install-example-data:
-	install -d $(DESTDIR)/home/.config/uzbl
-	install -d $(DESTDIR)/home/.cache/uzbl
-	install -d $(DESTDIR)/home/.local/share/uzbl
-	cp -rp examples/config/* $(DESTDIR)/home/.config/uzbl/
-	cp -rp examples/data/*   $(DESTDIR)/home/.local/share/uzbl/
+	install -d /usr/local/Cellar/uzbl/git/home/.config/uzbl
+	install -d /usr/local/Cellar/uzbl/git/home/.cache/uzbl
+	install -d /usr/local/Cellar/uzbl/git/home/.local/share/uzbl
+	cp -rp examples/config/* /usr/local/Cellar/uzbl/git/home/.config/uzbl/
+	cp -rp examples/data/*   /usr/local/Cellar/uzbl/git/home/.local/share/uzbl/
 
 uninstall:
 	rm -rf $(INSTALLDIR)/bin/uzbl-*
