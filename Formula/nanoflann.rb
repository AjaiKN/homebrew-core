class Nanoflann < Formula
  desc "Header-only library for Nearest Neighbor search wih KD-trees"
  homepage "https://github.com/jlblancoc/nanoflann"
  url "https://github.com/jlblancoc/nanoflann/archive/v1.5.0.tar.gz"
  sha256 "89aecfef1a956ccba7e40f24561846d064f309bc547cc184af7f4426e42f8e65"
  license "BSD-3-Clause"
  head "https://github.com/jlblancoc/nanoflann.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ebb58bcb45b28f2c97db50c849d97cf5e215d9ae9ecd580da7e04e1efde9ed81"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "gcc" => [:build, :test] if DevelopmentTools.clang_build_version <= 1200
  end

  fails_with :clang do
    build 1200
    cause "https://bugs.llvm.org/show_bug.cgi?id=23029"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DNANOFLANN_BUILD_EXAMPLES=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <nanoflann.hpp>
      int main() {
        nanoflann::KNNResultSet<size_t> resultSet(1);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11"
    system "./test"
  end
end
