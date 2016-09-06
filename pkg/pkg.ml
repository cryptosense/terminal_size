#use "topfind"
#require "topkg"
open Topkg

let () =
  Pkg.describe "terminal_size" @@ fun c ->
  Ok [ Pkg.mllib "src/terminal_size.mllib";
       Pkg.clib "src/libterminal_size_stubs.clib";
     ]
