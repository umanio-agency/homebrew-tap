class Skillctl < Formula
  desc "CLI to manage your personal agent skills library across projects"
  homepage "https://github.com/umanio-agency/skillctl"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/umanio-agency/skillctl/releases/download/v0.1.3/skillctl-aarch64-apple-darwin.tar.xz"
      sha256 "44d4d7082c3d9c8591af65c15e7f8ddec61de49ed444c641d21247fc49c9de12"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umanio-agency/skillctl/releases/download/v0.1.3/skillctl-x86_64-apple-darwin.tar.xz"
      sha256 "759aad422b315ff81675e6046ab0c7546d185c78e47c92d45432892b24792752"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/umanio-agency/skillctl/releases/download/v0.1.3/skillctl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9f36545726093b1e9b59236b02e10504c3a2af7ea71e0553d83e530fda6a5af6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umanio-agency/skillctl/releases/download/v0.1.3/skillctl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "382bcda731f01a8d0031ad0dc478d2cc6f5a0a272861a6dea8f2d34136c8a3cf"
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
