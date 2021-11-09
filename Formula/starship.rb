class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v1.0.0.tar.gz"
  sha256 "a66d47758b3dac4f1a626bb175c4847a2ef266540498a9f25222e715baf9f9db"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a60faabb96b0f5018d9eca0411cc0e62d426104393363aef5cf790b037f20bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5cdf15b3acc6d79796801ccecec7abbec07a80cd0930d8b8eb0ea0eca5c4234"
    sha256 cellar: :any_skip_relocation, monterey:       "47e6603e1e79ba5ada5023aeeff972bbddd44d9576ab5833dd67563f4a60d22c"
    sha256 cellar: :any_skip_relocation, big_sur:        "497ab79648951d3c78c19ad71e58059e1a810cf6acd70bac6e82369c61d7afd6"
    sha256 cellar: :any_skip_relocation, catalina:       "cf3eece649108cd3e0f0a06d60917798baa94df0b9e6cc5b47a9f74946bc5f71"
    sha256 cellar: :any_skip_relocation, mojave:         "b81cf067b32c42429b1509a9349cfd931e6b738429b52e221411c8d00af89098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c587f2f64efd31838b3c23ba82f13a0301d58e21a10b1795cf0c253ee55a7dae"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "dbus"
  end

  def install
    system "cargo", "install", "--features", "notify-rust", *std_cargo_args

    bash_output = Utils.safe_popen_read("#{bin}/starship", "completions", "bash")
    (bash_completion/"starship").write bash_output

    zsh_output = Utils.safe_popen_read("#{bin}/starship", "completions", "zsh")
    (zsh_completion/"_starship").write zsh_output

    fish_output = Utils.safe_popen_read("#{bin}/starship", "completions", "fish")
    (fish_completion/"starship.fish").write fish_output
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
