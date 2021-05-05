from conans import ConanFile, AutoToolsBuildEnvironment
from conans import tools
import os

class ATSConan(ConanFile):
    name = "ats-unit-testing-tests"
    version = "0.1"
    settings = "os", "compiler", "build_type", "arch"
    generators = "make"
    exports_sources = "*"
    requires = "ats-unit-testing/0.1@randy.valis/testing"

    def build(self):
        atools = AutoToolsBuildEnvironment(self)
        var = atools.vars
        var['ATSFLAGS'] = "-IATS" + " -IATS ".join([ self.deps_cpp_info[x].atsinclude for x in self.deps_cpp_info.deps ])
        atools.make(vars=var)

    def package(self):
        self.copy("target/tests", dst="target", keep_path=False)

    def deploy(self):
        self.copy("*", src="target", dst="bin")
