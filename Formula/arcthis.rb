class Arcthis < Formula
  desc "An agent-native CLI for accessing and manipulating compressed files"
  homepage "https://arcthis.mkynstudio.top"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mkynyd/arcthis/releases/download/v0.5.0/arcthis-aarch64-apple-darwin.tar.xz"
      sha256 "cf9f96b89f02340173c2b51c6450587a960be0e99118ee841fa685eea1b43f33"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mkynyd/arcthis/releases/download/v0.5.0/arcthis-x86_64-apple-darwin.tar.xz"
      sha256 "b7b492ddf221709b4bd53bcf0f70042bb7ac3a2c39c53d502244339d4b36e96d"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/mkynyd/arcthis/releases/download/v0.5.0/arcthis-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "c6e0a907efe33a2cb458ccb40809ba3c43bdc24bc160664e880d1bd8aa6ab418"
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
