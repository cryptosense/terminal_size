let test_enabled () =
  Unix.putenv "FAKE_ROWS" "1234";
  Unix.putenv "FAKE_COLS" "5678";
  Alcotest.check Alcotest.(option int) "rows" (Terminal_size.get_rows ()) (Some 1234);
  Alcotest.check Alcotest.(option int) "columns" (Terminal_size.get_columns ()) (Some 5678);
  Unix.putenv "FAKE_ROWS" "";
  Unix.putenv "FAKE_COLS" ""

let test_disabled () =
  Alcotest.check Alcotest.(option int) "rows" (Terminal_size.get_rows ()) None;
  Alcotest.check Alcotest.(option int) "columns" (Terminal_size.get_columns ()) None

let suite =
  [ "Terminal_size", [
      "enabled", `Quick, test_enabled;
      "disabled", `Quick, test_disabled;
    ]
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
  Alcotest.run "terminal_size" suite
