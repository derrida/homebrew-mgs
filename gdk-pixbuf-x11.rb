require 'formula'

class GdkPixbufX11 < Formula
  homepage 'http://gtk.org'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gdk-pixbuf/2.30/gdk-pixbuf-2.30.7.tar.xz'
  sha256 '0aafc365eab1083a53f15e4828333b968219ffcb1a995ac6289c0147c9ffad06'

  option :universal

  depends_on 'pkg-config' => :build
  depends_on :x11
  depends_on 'glib'
  depends_on 'libjpeg-turbo'
  depends_on 'libtiff'
  depends_on 'libpng'
  depends_on 'libsvg'
  depends_on 'gobject-introspection'

  # 'loaders.cache' must be writable by other packages
  skip_clean 'lib/gdk-pixbuf-2.0'

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--enable-debug=no",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes",
                          "--with-x11",
                          "--x-libraries=/opt/X11/lib",
                          "--x-includes=/opt/X11/include",
                          "--disable-Bsymbolic",
                          "--without-gdiplus"
    system "make"
    
    system "make install"

    # Other packages should use the top-level modules directory
    # rather than dumping their files into the gdk-pixbuf keg.
    inreplace lib/'pkgconfig/gdk-pixbuf-2.0.pc' do |s|
      libv = s.get_make_var 'gdk_pixbuf_binary_version'
      s.change_make_var! 'gdk_pixbuf_binarydir',
        HOMEBREW_PREFIX/'lib/gdk-pixbuf-2.0'/libv
    end
  end
end
