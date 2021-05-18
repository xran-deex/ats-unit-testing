from conans import ConanFile, AutoToolsBuildEnvironment
from conans import tools
import os

class ATSConan(ConanFile):
    name = "ats-unit-testing-tests"
    version = "0.1"
    settings = "os", "compiler", "build_type", "arch"
    generators = "atsmake"
    exports_sources = "*"
    requires = "ats-unit-testing/0.1@randy.valis/testing"

    def build(self):
        atools = AutoToolsBuildEnvironment(self)
        atools.make()

    def package(self):
        self.copy("target/tests", dst="target", keep_path=False)

    def deploy(self):
        self.copy("*", src="target", dst="bin")
