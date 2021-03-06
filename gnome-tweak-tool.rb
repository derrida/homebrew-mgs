require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class GnomeTweakTool < Formula
  homepage ""
  url "https://git.gnome.org/browse/gnome-tweak-tool/snapshot/gnome-tweak-tool-3.10.1.tar.gz"
  head "git://git.gnome.org/gnome-tweak-tool"
  sha1 ""

  depends_on "pkg-config" => :build
  # depends_on "cmake" => :build
  depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on "gtk+3"
  depends_on "pygobject3"
  depends_on "gettext"
  depends_on "python"
  depends_on "cairo"
  depends_on "gnome-common"
  depends_on "intltool"
  depends_on "pango"
  depends_on "libtool"
  depends_on "glib"
  depends_on "automake"
  depends_on "autoconf"
  depends_on "gsettings-desktop-schemas"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    system "./autogen.sh", "--disable-silent-rules", "--prefix=#{prefix}"
    # system "cmake", ".", *std_cmake_args
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test gnome`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
