#include "./../HATS/includes.hats"
#define ATS_DYNLOADFLAG 0
staload "libats/SATS/linmap_list.sats"

vtypedef test_struct =
    @{
        description=string,
        test=test_func,
        passed=bool
    }

vtypedef context_struct =
    @{
        passed=bool,
        msg=strptr,
        assert_called=bool
    }

vtypedef suite_struct =
    @{ 
        name=string,
        tests=List_vt(Test),
        num_passed=int,
        num_failed=int
    }

vtypedef runner_struct =
    @{ 
        suites=List_vt(Suite)
    }

datavtype test_vt = T of test_struct
datavtype context_vt = C of context_struct
datavtype suite_vt = S of suite_struct
datavtype runner_vt = R of runner_struct

assume Context = context_vt

implement tostring<Strptr1>(s) = copy s
implement tostring<int>(s) = tostrptr_int s

// weird, but eq_strptr_strptr isn't found
implement gequal_ref_ref<Strptr1>(a, b) = a = $UNSAFE.castvwtp1{string}(b)

implement {a:vt@ype} assert_equals0(ctx, e, a) = () where {
    val+@C(c) = ctx
    val equals = gequal_ref_ref<a>(e, a)
    val () = c.passed := equals
    val c1 = copy "\33[32mExpected: "
    val c2 = tostring<a>(e)
    val c3 = copy ", \33[31mActual: "
    val c4 = tostring<a>(a)
    val msg1 = strptr_append(c1, c2)
    val () = free(c1)
    val () = free(c2)
    val msg2 = strptr_append(msg1, c3)
    val () = free(c3)
    val () = free(msg1)
    val msg3 = strptr_append(msg2, c4)
    val () = free(c4)
    val () = free(msg2)
    val () = free(c.msg)
    val () = c.msg := msg3
    val () = c.assert_called := true
    prval() = fold@(ctx)
}

implement {a:vt@ype} assert_equals0_msg(ctx, e, a, msg) = () where {
    val+@C(c) = ctx
    val equals = gequal_ref_ref<a>(e, a)
    val () = c.passed := equals
    val () = free(c.msg)
    val () = c.msg := copy msg
    val () = c.assert_called := true
    prval() = fold@(ctx)
}

implement {a} assert_equals1(ctx, e, a) = () where {
    val+@C(c) = ctx
    val equals = gequal_val_val<a>(e, a)
    val () = c.passed := equals
    val c1 = copy "Expected: "
    val c2 = tostring<a>(e)
    val c3 = copy ", Actual: "
    val c4 = tostring<a>(a)
    val msg1 = strptr_append(c1, c2)
    val () = free(c1)
    val () = free(c2)
    val msg2 = strptr_append(msg1, c3)
    val () = free(c3)
    val () = free(msg1)
    val msg3 = strptr_append(msg2, c4)
    val () = free(c4)
    val () = free(msg2)
    val () = free(c.msg)
    val () = c.msg := msg3
    val () = c.assert_called := true
    prval() = fold@(ctx)
}

implement {a} assert_equals1_msg(ctx, e, a, msg) = () where {
    val+@C(c) = ctx
    val equals = gequal_val_val<a>(e, a)
    val () = c.passed := equals
    val () = free(c.msg)
    val () = c.msg := copy msg
    val () = c.assert_called := true
    prval() = fold@(ctx)
}

implement{} assert_true(ctx, b) = () where {
    val+@C(c) = ctx
    val () = c.passed := b
    val () = c.assert_called := true
    prval() = fold@(ctx)
}

implement{} assert_true_msg(ctx, b, msg) = () where {
    val+@C(c) = ctx
    val () = c.passed := b
    val () = free(c.msg)
    val () = c.msg := copy msg
    val () = c.assert_called := true
    prval() = fold@(ctx)
}

assume Test = test_vt
assume Suite = suite_vt
assume Runner = runner_vt

implement{} create_suite(name) = suite where {
    val suite = S(_)
    val S(s) = suite
    val () = s.name := name
    val () = s.tests := list_vt_nil()
    val () = s.num_passed := 0
    val () = s.num_failed := 0
    prval() = fold@(suite)
}

implement{} free_suite(suite) = () where {
    val+~S(s) = suite
    val () = list_vt_freelin(s.tests) where {
        implement list_vt_freelin$clear<test_vt>(t) = () where {
            val+~T(_) = t
        }
    }
}

implement{} create_runner() = runner where {
    val runner = R(_)
    val R(r) = runner
    val () = r.suites := list_vt_nil()
    prval() = fold@(runner)
}

implement{} free_runner(runner) = () where {
    val+~R(r) = runner
    val () = list_vt_freelin(r.suites) where {
        implement list_vt_freelin$clear<suite_vt>(s) = free_suite(s)
    }
}

implement{} add_suite(runner, suite) = () where {
    val+@R(r) = runner
    val () = assertloc(list_vt_length(r.suites) >= 0)
    val () = r.suites := list_vt_cons(suite, r.suites)
    prval() = fold@(runner)
}

implement{} add_test(suite, n, t) = () where {
    val+@S(s) = suite
    val test = T(_)
    val+ T(te) = test
    val () = te.description := n
    val () = te.test := t
    val () = te.passed := false
    prval() = fold@(test)
    val () = assertloc(list_vt_length(s.tests) >= 0)
    val () = s.tests := list_vt_cons(test, s.tests)
    prval() = fold@(suite)
}

implement{} run_tests(runner) = () where {
    val+@R(r) = runner
    val () = r.suites := list_vt_reverse(r.suites)
    val () = list_vt_foreach(r.suites) where {
        implement(env) list_vt_foreach$fwork<suite_vt><env>(suite, ev) = () where {
            val+@S(s) = suite
            val () = s.tests := list_vt_reverse(s.tests)
            val () = println!("Running suite: ", s.name, "\n")
            typedef env = @{ num_passed=int, num_failed=int }
            var e: env = @{ num_passed=0, num_failed=0 }
            val () = list_vt_foreach_env<Test><env>(s.tests, e) where {
                implement list_vt_foreach$fwork<Test><env>(test, e2) = () where {
                    val+@T(t) = test
                    val ctx = C(_)
                    val C(c) = ctx
                    val () = c.passed := false
                    val () = c.assert_called := false
                    val () = c.msg := copy ""
                    prval () = fold@(ctx)
                    val () = t.test(ctx)
                    val+@C(c) = ctx
                    val () = if c.passed
                             then println!(t.description, ": \33[32mpassed\33[0m")
                             else () where {
                                 val () = if c.assert_called
                                          then println!(t.description, ": \33[31mfailed\33[0m\tError: \33[31m", c.msg, "\33[0m")//, "Loc: ", $mylocation)
                                          else println!(t.description, ": \33[31mfailed\33[0m\tError: \33[31mNo assertions made\33[0m")//, "Loc: ", $mylocation)
                             }
                    val () = case+ c.passed of
                             | true => e2.num_passed := e2.num_passed + 1
                             | false => e2.num_failed := e2.num_failed + 1
                    prval () = fold@(ctx)
                    val+~C(c) = ctx
                    val () = free(c.msg)
                    prval () = fold@(test)
                }
            }
            val () = s.num_failed := e.num_failed
            val () = s.num_passed := e.num_passed
            val () = println!("\n\tTotal passed: \33[32m", s.num_passed, "\33[0m")
            val () = if s.num_failed > 0 then
                        println!("\tTotal failed: \33[31m", s.num_failed, "\33[0m")
                     else
                        println!("\tTotal failed: \33[32m", s.num_failed, "\33[0m")
            prval() = fold@(suite)
        }
    }
    prval() = fold@(runner)
}