[![Build Status](https://cloud.drone.io/api/badges/xran-deex/ats-unit-testing/status.svg)](https://cloud.drone.io/xran-deex/ats-unit-testing)

# ats-unit-testing

A (super simple) unit testing library for ATS2

## Example
```ats
#include "./../ats-unit-testing.hats"

fn add(x: int, y: int): int = x + y

fn test1(c: &Context): void = () where {
    val x = "hello"
    val y = "hellx"
    val () = assert_equals1_msg<string>(c, x, y, "Strings don't match")
}

fn test2(c: &Context): void = () where {
    var x = copy "hello"
    var y = copy "hellx"
    val () = assert_equals0<Strptr1>(c, x, y)
    val () = free(x)
    val () = free(y)
}

fn test3(c: &Context): void = () where {
    val x: int = 6
    val y: int = 7
    val z = add(x, y)
    val () = assert_equals1<int>(c, 12, z)
}

implement main(argc, argv) = 0 where {
    val r = create_runner()
    val s = create_suite("Hello Tests")

    val () = add_test(s, "test1", test1)
    val () = add_test(s, "test2", test2)
    val () = add_test(s, "test3", test3)

    val () = add_suite(r, s)
    val () = run_tests(r)
    val () = free_runner(r)
}
```

## Output
```bash
Running suite: Hello Tests

test1: failed   Error: Strings don't match
test2: failed   Error: Expected: hello, Actual: hellx
test3: failed   Error: Expected: 12, Actual: 13
test4: failed   Error: 12 expected
test5: passed
test6: failed   Error: No assertions made

        Total passed: 1
        Total failed: 5
```

## API
```ats
// assert that 2 viewtypes are equal
fn{a:vt@ype} assert_equals0(c: !Context, expected: &a, actual: &a): void

// similar to assert_equals0, except print a message if the assertion fails
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
```