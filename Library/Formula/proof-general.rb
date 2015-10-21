class ProofGeneral < Formula
  desc "Emacs-based generic interface for theorem provers"
  homepage "http://proofgeneral.inf.ed.ac.uk"
  url "http://proofgeneral.inf.ed.ac.uk/releases/ProofGeneral-4.2.tgz"
  sha256 "3567b68077798396ccd55c501b7ea7bd2c4d6300e4c74ff609dc19837d050b27"

  devel do
    url "http://proofgeneral.inf.ed.ac.uk/releases/ProofGeneral-4.3pre150930.tgz"
    version "4.3pre150930"
    sha256 "5f3f943cc6c7c5f5ff344a01b25054a62877f090f382b1c84917906cfea367bc"
  end

  depends_on :emacs => "22.3"

  def install
    ENV.j1 # Otherwise lisp compilation can result in 0-byte files

    args = %W[
      PREFIX=#{prefix}
      DEST_PREFIX=#{prefix}
      ELISPP=share/emacs/site-lisp/proof-general
      ELISP_START=#{share}/emacs/site-lisp/proof-general/site-start.d
      EMACS=#{which "emacs"}
    ]

    cd "ProofGeneral" do
      # http://proofgeneral.inf.ed.ac.uk/trac/ticket/458
      # remove in next stable release
      inreplace "Makefile", "(setq byte-compile-error-on-warn t)", "" if build.stable?
      # remove files compiled by emacs 24.2
      system "make", "clean"
      system "make", "install", *args

      man1.install "doc/proofgeneral.1"
      info.install "doc/ProofGeneral.info", "doc/PG-adapting.info"
      doc.install "doc/ProofGeneral", "doc/PG-adapting"
    end
  end

  def caveats; <<-EOS.undent
    HTML documentation is available in: #{HOMEBREW_PREFIX}/share/doc/proof-general
  EOS
  end

  test do
    system bin/"proofgeneral", "--help"
  end
end
