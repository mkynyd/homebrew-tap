class Arcthis < Formula
  desc "A command-line tool for reading and managing compressed files"
  homepage "https://arcthis.mkynstudio.top"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mkynyd/arcthis/releases/download/v0.5.1/arcthis-aarch64-apple-darwin.tar.xz"
      sha256 "7b2983cb67c0d526707f2d677439e408fc770aa81a2f34219aa4e5ac077e884c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mkynyd/arcthis/releases/download/v0.5.1/arcthis-x86_64-apple-darwin.tar.xz"
      sha256 "d3ac85373ddc8c601c6803cfc2a2f5cbd66bccdf8e5bf1007434eb15c07fa683"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/mkynyd/arcthis/releases/download/v0.5.1/arcthis-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "8b8cdac25e366603fc296f150ee846f36109689ccffb91af00c61303b777ec82"
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
