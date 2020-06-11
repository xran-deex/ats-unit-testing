#include "share/atspre_define.hats"
#include "share/atspre_staload.hats"
staload "libats/SATS/linmap_list.sats"

absvt@ype Context
absvt@ype Test
absvt@ype Suite
absvt@ype Runner

typedef test_func = (&Context) -<fun1> void

fn{a:vt@ype} assert_equals0(c: !Context, expected: &a, actual: &a): void
fn{a:vt@ype} assert_equals0_msg(c: !Context, expected: &a, actual: &a, msg: string): void
fn{a:t@ype} assert_equals1(c: !Context, expected: a, actual: a): void
fn{a:t@ype} assert_equals1_msg(c: !Context, expected: a, actual: a, msg: string): void
fn{} assert_true(c: !Context, b: bool): void
fn{} assert_true_msg(c: !Context, b: bool, msg: string): void

fn{} create_suite(name: string): Suite
fn{} create_runner(): Runner
fn{} free_suite(name: Suite):<!wrt> void
fn{} free_runner(name: Runner):<!wrt> void
fn{} add_suite(runner: !Runner, suite: Suite): void
fn{} add_test(suite: !Suite, desc: string, test: test_func): void
fn{} run_tests(runner: !Runner): void

fn {a:vt@ype} tostring(v: !a): strptr