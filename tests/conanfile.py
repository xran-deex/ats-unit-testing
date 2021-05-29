from atsconan import ATSConan

class ATSConan(ATSConan):
    name = "ats-unit-testing-tests"
    version = "0.1"
    requires = "ats-unit-testing/0.1@randy.valis/testing"

    def package(self):
        self.copy("target/tests", dst="target", keep_path=False)

    def deploy(self):
        self.copy("*", src="target", dst="bin")
