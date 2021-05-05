from conans import ConanFile, AutoToolsBuildEnvironment
from conans import tools
import os

class ATSConan(ConanFile):
    name = "ats-unit-testing"
    version = "0.1"
    settings = "os", "compiler", "build_type", "arch"
    generators = "make"
    exports_sources = "*"

    def build(self):
        atools = AutoToolsBuildEnvironment(self)
        atools.fpic = True
        atools.make()

    def package(self):
        self.copy("*.hats")
        self.copy("*.dats")
        self.copy("*.sats")
        #self.copy("*.so", dst="lib", keep_path=False)
        #self.copy("*.a", dst="lib", keep_path=False)

    def package_info(self):
        #self.cpp_info.libs = ["ats-unit-testing"]
        self.cpp_info.atsinclude = os.path.join(self.package_folder, "src")
