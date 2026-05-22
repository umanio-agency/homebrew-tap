class Skillctl < Formula
  desc "CLI to manage your personal agent skills library across projects"
  homepage "https://github.com/umanio-agency/skillctl"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/umanio-agency/skillctl/releases/download/v0.1.4/skillctl-aarch64-apple-darwin.tar.xz"
      sha256 "e7291b17e90bce3991fae702978d803d82d624b7e27588340648e1ab294c8af7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umanio-agency/skillctl/releases/download/v0.1.4/skillctl-x86_64-apple-darwin.tar.xz"
      sha256 "27e25e890554193615a856d2679b5a888f76773c1fb5d40ada85bb13ada25879"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/umanio-agency/skillctl/releases/download/v0.1.4/skillctl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8ca1366d47c7d7283fd69311bbddde1a94929c20a877487825f19469c12fd8e1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umanio-agency/skillctl/releases/download/v0.1.4/skillctl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "09c8ce1f8b1fc1399791b85b6ba848a767752f2b3410550660a666bb0cff72bd"
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
