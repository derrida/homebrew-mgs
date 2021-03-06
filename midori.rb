require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Midori < Formula
  homepage ""
  url "http://midori-browser.org/downloads/midori_0.5.8_all_.tar.bz2"
  sha1 "238bbf4935e409bc41fcba5b8407f3e30ea017f6"
  head "https://code.launchpad.net/midori", :using => :bzr
  
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "sqlite" => :build
  
  depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on "readline"
  depends_on "librsvg"
  depends_on "libxml2"
  depends_on "glib"
  depends_on "glib-networking"
  depends_on "gtk+"
  depends_on "gtk+3"
  depends_on "gnome-common"
  depends_on "glib"
  depends_on "libsoup"
  depends_on "webkit-gtk3"
  depends_on "libnotify"
  depends_on "libunique"
  depends_on "vala"

  #patch :p1 do
      #url "file:///Users/mgs/midori-gtk3osxfix.patch"
  #end

  #patch :p1 do
      #url "file:///Users/mgs/midori-gtk3osxfix-2.patch"
  #end

  patch :p1 do
      url "file:///Users/mgs/midori-gtk3.patch"
  end

  patch :p1 do
      url "file:///Users/mgs/midori-gtk3-2.patch"
  end

  def install
    #ENV.deparallelize  # if your formula fails when building in parallel
    
    # Remove unrecognized options if warned by configure
    #system "sh autogen.sh"
    
    system "cmake", ".", "-DUSE_GIR=OFF", "-DUSE_GTK3=ON", "-DUSE_ZEITGEIST=OFF", *std_cmake_args
    
    #system "./configure", "--prefix=#{prefix}"
    
    system "make"
    
    # system "install_name_tool -id #{buildpath}/lib/libmidori-core.1.dylib #{prefix}/lib/libmidori-core.1.dylib"
    # system "install_name_tool -change libmidori-core.1.dylib #{prefix}/lib/libmidori-core.1.dylib #{buildpath}/bin/midori"
    
    # Dir.glob("#{buildpath}/lib/midori/*.so").each {
    #     system "install_name_tool -change libmidori-core.1.dylib #{prefix}/lib/libmidori-core.1.dylib |file|"
    # }
    system "make install" # if this fails, try separate make/make install steps
  end

end
