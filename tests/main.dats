#include "share/atspre_define.hats"
#include "share/atspre_staload.hats"
#include "./../ats-unit-testing.hats"

implement gequal_ref_ref<strptr>(x, y) = compare_strptr_strptr(x,y) = 0
implement tostring<double>(x) = copy(tostring_double(x))

fn add(x: int, y: int): int = x + y

fn test1(c: !Context): void = () where {
    val x = "hello"
    val y = "hellx"
    val () = assert_equals1_msg<string>(c, x, y, "Strings don't match")
}

fn test2(c: !Context): void = () where {
    var x = copy "hello"
    var y = copy "hellx"
    val () = assert_equals0<Strptr1>(c, x, y)
    val () = free(x)
    val () = free(y)
}

fn test3(c: !Context): void = () where {
    val x: int = 6
    val y: int = 7
    val z = add(x, y)
    val () = assert_equals1<int>(c, 12, z)
}

fn test4(c: !Context): void = () where {
    val x = 6
    val y = 7
    val z = add(x, y)
    val () = assert_true_msg(c, 12 = z, "12 expected")
}

implement main(argc, argv) = 0 where {
    val r = create_runner()
    val s = create_suite("Hello Tests")

    val () = add_test(s, "test1", test1)
    val () = add_test(s, "test2", test2)
    val () = add_test(s, "test3", test3)
    val () = add_test(s, "test4", test4)
    val () = add_test(s, "test5", fnc) where {
        fn fnc(c: !Context): void = assert_equals1<double>(c, x, y) where {
            val x = 2.0
            val y = 2.0
        }
    }

    val () = add_suite(r, s)
    val () = run_tests(r)
    val () = free_runner(r)
}