class ApacheArrowAT8 < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  # Note - SDK's built ontop of this demand an exact version match - bump this only in lockstep with them
  # e.g. required_pkg_config_package on https://github.com/apache/arrow/blob/master/ruby/red-arrow/ext/arrow/extconf.rb
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-8.0.0/apache-arrow-8.0.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-8.0.0/apache-arrow-8.0.0.tar.gz"
  sha256 "ad9a05705117c989c116bae9ac70492fe015050e1b80fb0e38fde4b5d863aaa3"
  license "Apache-2.0"
  revision 5
  head "https://github.com/apache/arrow.git", branch: "master"

  depends_on "boost" => :build
  depends_on "cmake" => :build
  # Find supported LLVM versions in the arrow release definition of ARROW_LLVM_VERSIONS
  # https://github.com/apache/arrow/blob/release-8.0.0/cpp/CMakeLists.txt#L113-L122
  depends_on "llvm@14" => :build
  depends_on "aws-sdk-cpp"
  depends_on "brotli"
  depends_on "glog"
  depends_on "grpc"
  depends_on "lz4"
  depends_on "numpy"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "python@3.10"
  depends_on "rapidjson"
  depends_on "re2"
  depends_on "snappy"
  depends_on "thrift"
  depends_on "utf8proc"
  depends_on "zstd"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    # https://github.com/Homebrew/homebrew-core/issues/76537
    # ENV.runtime_cpu_detection if Hardware::CPU.intel?

    # https://github.com/Homebrew/homebrew-core/issues/94724
    # https://issues.apache.org/jira/browse/ARROW-15664
    ENV["HOMEBREW_OPTIMIZATION_LEVEL"] = "O2"

    args = %W[
      -DCMAKE_FIND_PACKAGE_PREFER_CONFIG=TRUE
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DARROW_FLIGHT=ON
      -DARROW_GANDIVA=ON
      -DARROW_JEMALLOC=ON
      -DARROW_ORC=ON
      -DARROW_PARQUET=ON
      -DARROW_PLASMA=ON
      -DARROW_PROTOBUF_USE_SHARED=ON
      -DARROW_PYTHON=ON
      -DARROW_S3=ON
      -DARROW_WITH_BZ2=ON
      -DARROW_WITH_ZLIB=ON
      -DARROW_WITH_ZSTD=ON
      -DARROW_WITH_LZ4=ON
      -DARROW_WITH_SNAPPY=ON
      -DARROW_WITH_BROTLI=ON
      -DARROW_WITH_UTF8PROC=ON
      -DARROW_INSTALL_NAME_RPATH=OFF
      -DPython3_EXECUTABLE=#{which("python3")}
    ]

    args << "-DARROW_MIMALLOC=ON" unless Hardware::CPU.arm?

    system "cmake", "-S", "cpp", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "arrow/api.h"
      int main(void) {
        arrow::int64();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system "./test"
  end
end
