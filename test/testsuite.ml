open OUnit2

let test_enabled ctxt =
  Unix.putenv "FAKE_ROWS" "1234";
  Unix.putenv "FAKE_COLS" "5678";
  assert_equal ~ctxt (Terminal_size.get_rows ()) (Some 1234);
  assert_equal ~ctxt (Terminal_size.get_columns ()) (Some 5678);
  Unix.putenv "FAKE_ROWS" "";
  Unix.putenv "FAKE_COLS" ""

let test_disabled ctxt =
  assert_equal ~ctxt (Terminal_size.get_rows ()) None;
  assert_equal ~ctxt (Terminal_size.get_columns ()) None

let suite =
  "Terminal_size" >::: [
    "enabled" >:: test_enabled;
    "disabled" >:: test_disabled;
  ]

let preload () =
  try ignore (Unix.getenv "LD_PRELOAD") with Not_found ->
    begin
      let exe = Sys.argv.(0) in
      let args = [|exe|] in
      let env =
        [|
          "LD_PRELOAD=./_build/test/dllmock_ioctl.so";
          "FAKE_ROWS=";
          "FAKE_COLS=";
        |]
      in
      Unix.execve exe args env
    end

let () =
  preload ();
  run_test_tt_main suite
