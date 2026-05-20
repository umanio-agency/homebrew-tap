class Skillctl < Formula
  desc "CLI to manage your personal agent skills library across projects"
  homepage "https://github.com/umanio-agency/skillctl"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/umanio-agency/skillctl/releases/download/v0.1.2/skillctl-aarch64-apple-darwin.tar.xz"
      sha256 "fe10793a886b6d3b47e2174cdf3020d7906f1d02ef9ac57d6bd7cb9262a2a657"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umanio-agency/skillctl/releases/download/v0.1.2/skillctl-x86_64-apple-darwin.tar.xz"
      sha256 "0fe0119567a9784e33beac0231312f685c93faa24973d3d86a5235c74ddc62a6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/umanio-agency/skillctl/releases/download/v0.1.2/skillctl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "76922a06ccc3093037ffa8e8f15d9edaccbae1347597dcad2f16a4d7c73a31df"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umanio-agency/skillctl/releases/download/v0.1.2/skillctl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "38e38832b0e18fce181e3954e20e54d23c2a708b9a39270e0ee840fd399d51c4"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "skillctl" if OS.mac? && Hardware::CPU.arm?
    bin.install "skillctl" if OS.mac? && Hardware::CPU.intel?
    bin.install "skillctl" if OS.linux? && Hardware::CPU.arm?
    bin.install "skillctl" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
