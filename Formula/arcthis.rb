class Arcthis < Formula
  desc "A command-line tool for reading and managing compressed files"
  homepage "https://arcthis.mkynstudio.top"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mkynyd/arcthis/releases/download/v0.6.0/arcthis-aarch64-apple-darwin.tar.xz"
      sha256 "88b52969fae600da9f99df92bd668298c88ba2010f48a62e96353dc7aad0a5a4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mkynyd/arcthis/releases/download/v0.6.0/arcthis-x86_64-apple-darwin.tar.xz"
      sha256 "7025c6fb31d89b6b92b115f584d6f324f1608eb22c7734e676fea5e1314f15d7"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/mkynyd/arcthis/releases/download/v0.6.0/arcthis-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "c06ff32880f9e78b499231f6428f8affad115081ec6c0d402292c02e79fac694"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-apple-darwin":      {},
    "x86_64-unknown-linux-gnu": {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "arcthis"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "arcthis"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "arcthis"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
