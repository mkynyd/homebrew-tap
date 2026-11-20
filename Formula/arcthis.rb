class Arcthis < Formula
  desc "A command-line tool for reading and managing compressed files"
  homepage "https://arcthis.mkynstudio.top"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mkynyd/arcthis/releases/download/v0.7.0/arcthis-aarch64-apple-darwin.tar.xz"
      sha256 "a33a8672fc19eaa2730f90baff49e47f4450ab6952b68152d5658a53e911f042"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mkynyd/arcthis/releases/download/v0.7.0/arcthis-x86_64-apple-darwin.tar.xz"
      sha256 "9f640a8a54f145644d5bf1d1e7e8c7898d61ad92a7229128fa334960ebbdb6be"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/mkynyd/arcthis/releases/download/v0.7.0/arcthis-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "6d04913b5bb27e645f4fe08aa31f65fa035534d521b78da911c5e9671b429fd0"
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
