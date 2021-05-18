from atsconan import ATSConan

class ATSConan(ATSConan):
    name = "ats-unit-testing"
    version = "0.1"
    settings = "os", "compiler", "build_type", "arch"
    exports_sources = "*"