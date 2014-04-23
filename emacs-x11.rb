require 'formula'

class EmacsX11 < Formula
    homepage 'http://www.gnu.org/software/emacs/'
    url 'bzr://http://bzr.savannah.gnu.org/r/emacs/trunk'
    sha256 '0098ca3204813d69cd8412045ba33e8701fa2062f4bff56bedafc064979eef41'

    skip_clean 'share/info' # Keep the docs

    option "use-git-head", "Use Savannah (faster) git mirror for HEAD builds"
    option "keep-ctags", "Don't remove the ctags executable that emacs provides"

    head do
        if build.include? "use-git-head"
            url 'http://git.sv.gnu.org/r/emacs.git'
        else
            url 'bzr://http://bzr.savannah.gnu.org/r/emacs/trunk'
        end
    end

    depends_on 'pkg-config' => :build
    depends_on :x11
    depends_on :autoconf
    depends_on :automake
    depends_on 'gnutls'
    depends_on 'gtk+3'

    fails_with :llvm do
        build 2334
        cause "Duplicate symbol errors while linking."
    end

    # Follow MacPorts and don't install ctags from Emacs. This allows Vim
    # and Emacs and ctags to play together without violence.
    def do_not_install_ctags
        unless build.include? "keep-ctags"
            (bin/"ctags").unlink
            (share/man/man1/"ctags.1.gz").unlink
        end
    end

    def install
        # HEAD builds blow up when built in parallel as of April 20 2012
        #ENV.j1 if build.head?

        args = ["--prefix=#{prefix}",
                "--with-dbus",
                    "--with-gnutls",
                    "--enable-locallisppath=#{HOMEBREW_PREFIX}/share/emacs/site-lisp",
                "--with-x",
                    "--x-includes=/opt/X11/include",
                    "--x-libraries=/opt/X11/lib",
                    "--with-gif=no",
                    "--with-tiff=no",
                    "--with-jpeg=no",
                    "--with-x-toolkit=gtk3",
                    "--with-gif=yes",
                    "--with-tiff=yes",
                    "--with-jpeg=yes",
                    "--infodir=#{info}/emacs"]

        system "./autogen.sh"
        # These libs are not specified in xft's .pc. See:
        # https://trac.macports.org/browser/trunk/dports/editors/emacs/Portfile#L74
        # https://github.com/Homebrew/homebrew/issues/8156
        ENV.append 'LDFLAGS', '-lfreetype -lfontconfig'

        system "./configure", *args
        system "make"
        system "make install"

        # Don't cause ctags clash.
        do_not_install_ctags
    end

    test do
        output = `'#{bin}/emacs' --batch --eval="(print (+ 2 2))"`
        assert $?.success?
        assert_equal "4", output.strip
    end
end
