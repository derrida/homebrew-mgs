require 'formula'

class WebkitGtk3 < Formula
  homepage ''
  head 'git://git.webkit.org/WebKit.git'
  url 'http://webkitgtk.org/releases/webkitgtk-2.4.0.tar.xz'
  sha1 'd7dade39ebeded72ddf7ac37a9d9ed17ac68dcba'
  sha256 'dc5277cda89ee038408f78c94b1b07f101997f01ef877a142ffedac3b537dfbb'
  
  depends_on 'pkg-config' => :build
  depends_on 'gtk-doc' => :build
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'autogen' => :build
  depends_on 'bison' => :build
  depends_on 'flex' => :build
  depends_on 'icu4c' => :build
  depends_on 'intltool' => :build
  depends_on 'libtool' => :build
  depends_on 'make' => :build
  depends_on 'libsoup' => :build


  depends_on :x11
  depends_on 'cairo'
  depends_on 'cairomm'
  depends_on 'glib'
  depends_on 'enchant'
  depends_on 'geoclue' ## Unofficial Recipe
  depends_on 'libsecret' ## Unofficial Recipe
  depends_on 'gobject-introspection'
  depends_on 'harfbuzz'
  depends_on 'libxslt'
  depends_on 'libpng'
  depends_on 'mesalib-glw'
  depends_on 'webp'
  depends_on 'sqlite'
  depends_on 'gtk+'
  depends_on 'gtk+3'
  depends_on 'gstreamer'
  depends_on 'gst-plugins-base'

  #depends_on 'gettext'
  #depends_on 'zlib'
  #depends_on 'gnome-common'
  #depends_on 'sdl'

  patch :p0 do
    url "https://trac.macports.org/export/118612/trunk/dports/www/webkit-gtk/files/clang-assertions.patch"
    sha1 "7a2693b500abbc4dcb14f2755d526c60ac9fd64e"
  end

  patch :p0 do
    url "https://trac.macports.org/export/118612/trunk/dports/www/webkit-gtk/files/case-insensitive.patch"
    sha1 "6669097ffb1cb37a47230ad9d37f1fae26de3c72"
  end

  patch :p0 do
    url "https://trac.macports.org/export/118612/trunk/dports/www/webkit-gtk/files/our-icu.patch"
    sha1 "2d20220d07d8f63cca76313e9a2d22c3f3d0fa5f"
  end

  patch :p0 do
    url "https://trac.macports.org/export/118612/trunk/dports/www/webkit-gtk/files/quartz-duplicate-symbols.patch"
    sha1 "a8ca0b35a0d6af3fd0b33a54cb31404f3240aaaf"
  end

  patch :p0 do
    url "https://trac.macports.org/export/118612/trunk/dports/www/webkit-gtk/files/quartz-webcore.patch"
    sha1 "1b9048a72a1e8df2d85fb1454dfe856c1acc62a5"
  end

  patch :p0 do
    url "https://trac.macports.org/export/118612/trunk/dports/www/webkit-gtk/files/clang-check.patch"
    sha1 "f992561c37994bc388ef755b65526cf3e5fac057"
  end

  patch :p0 do
    url "https://trac.macports.org/export/118612/trunk/dports/www/webkit-gtk/files/gstreamer.patch"
    sha1 "da45ecbcf6336a4c9382e5a242d392bc213bb41d"
  end
  
  patch :p0 do
    url "https://trac.macports.org/export/118612/trunk/dports/www/webkit-gtk/files/libedit.patch"
    sha1 "8b16dd98a9e03f3d505cc4cb5b79b73fba756977"
  end

  def install
    ENV.deparallelize

    # Use the system python
    ENV['PYTHON']='/usr/bin/python'

    # # gobject-introspection uses g-ir-scanner, uses $CC from environment
    #ENV['CC']="/usr/local/opt/ccache/libexec/clang -arch x86_64"
    #ENV['CXX']="/usr/local/opt/ccache/libexec/clang -arch x86_64"
    #ENV['LD']="/usr/bin/ld"

    #ENV['AR']="/usr/bin/ar"
    #ENV['RANLIB']="/usr/bin/ranlib"
    #ENV['STRIP']="/usr/bin/strip"

    #don't use the headers from the installed webkit
    ENV.remove 'CPPFLAGS', "-I#{prefix}/include"

    # google-test suite build fix
    ENV.append 'CPPFLAGS', "-DGTEST_USE_OWN_TR1_TUPLE=1"

    # macports fix
    ENV.append 'CFLAGS', "-ftemplate-depth=256"
    ENV.append 'CXXFLAGS', "-ftemplate-depth=256"

    ENV['ACLOCAL']="aclocal -I Source/autotools"

    ENV.append 'CXXFLAGS', "-Wno-c++11-extensions"
    system "autoreconf", "-fvi"

    inreplace "Source/JavaScriptCore/API/WebKitAvailability.h",
              /def __APPLE__/,
              ' 0'
    
    inreplace "Source/WTF/wtf/ThreadingPthreads.cpp",
              /OS(MAC_OS_X)/,
              'PLATFORM(MAC)'
    
    inreplace "Source/JavaScriptCore/API/JSBase.h",
              /^#define JSC_OBJC_API_ENABLED.*/,
              '#define JSC_OBJC_API_ENABLED 0'
    
    #inreplace "#{buildpath}/Source/autotools/SetupCompilerFlags.m4", /-stdlib=libstdc\+\+/, ''
    
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-introspection",
                          "--disable-gtk-doc",
                          "--disable-webkit2",
                          "--disable-web-audio",
                          "--enable-video",
                          "--with-gtk=3.0",
                          "--enable-credential-storage",
                          "--enable-svg",
                          "--enable-geolocation"
    system "make V=1"
    system "make install"
  end
end
