class Skillctl < Formula
  desc "CLI to manage your personal agent skills library across projects"
  homepage "https://github.com/umanio-agency/skillctl"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/umanio-agency/skillctl/releases/download/v0.1.8/skillctl-aarch64-apple-darwin.tar.xz"
      sha256 "975b29acacb54e36e8cf9a1592bdd49693bb83edd68ef50dd4ad890a8a312e36"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umanio-agency/skillctl/releases/download/v0.1.8/skillctl-x86_64-apple-darwin.tar.xz"
      sha256 "3c0587ce8e48151869c779649c64d78604fb8342a93a9ed0bd9069439dd890e7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/umanio-agency/skillctl/releases/download/v0.1.8/skillctl-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3ea3019d617046cbbc75989eeb72bf664dd9b21715859b997c248c3af891a694"
    end
    if Hardware::CPU.intel?
      url "https://github.com/umanio-agency/skillctl/releases/download/v0.1.8/skillctl-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9d180c4b5028250cf01c2c5fe123e828d49dd2e31e703573c6713da8d46adf71"
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
