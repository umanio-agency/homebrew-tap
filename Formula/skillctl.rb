class Skillctl < Formula
  desc "CLI to manage your personal agent skills library across projects"
  homepage "https://github.com/umanio-agency/skillctl"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/umanio-agency/skillctl/releases/download/v0.1.7/skillctl-aarch64-apple-darwin.tar.xz"
      sha256 "e45afcc304328ec7e1aeec3e6e7d787bc74c9be1394937abbfee3c8562c8e9ff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umanio-agency/skillctl/releases/download/v0.1.7/skillctl-x86_64-apple-darwin.tar.xz"
      sha256 "5a21d3c67981615026e23bf7333c2aaa3c47337a7612cf3d31ad883249fff02b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/umanio-agency/skillctl/releases/download/v0.1.7/skillctl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7970d7306afc3efb1ac4fb283a47a4104026ccbc64883fcf8c039c02318bb64c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umanio-agency/skillctl/releases/download/v0.1.7/skillctl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c14adab351096fb95d2cbb5af951e6649ea3f445412311358e5f377aa3254b95"
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
