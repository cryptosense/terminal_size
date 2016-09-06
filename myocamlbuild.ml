open Ocamlbuild_plugin

let () =
  dispatch begin function
  | After_rules ->
    flag ["library"; "link"; "byte"; "use_terminal_size"]
        (S ([A "-dllib"; A "-lterminal_size_stubs"]));
    flag ["library"; "link"; "native"; "use_terminal_size"]
        (S ([A "-cclib"; A "-lterminal_size_stubs"]));
      flag ["link"; "ocaml"; "link_terminal_size"]
        (A "src/libterminal_size_stubs.a");
      dep ["link"; "ocaml"; "use_terminal_size"]
        ["src/libterminal_size_stubs.a"];
  | _ -> ()
  end
