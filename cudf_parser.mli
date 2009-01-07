(*****************************************************************************)
(*  libCUDF - CUDF (Common Upgrade Description Format) manipulation library  *)
(*  Copyright (C) 2009  Stefano Zacchiroli <zack@pps.jussieu.fr>             *)
(*                                                                           *)
(*  This library is free software: you can redistribute it and/or modify     *)
(*  it under the terms of the GNU Lesser General Public License as           *)
(*  published by the Free Software Foundation, either version 3 of the       *)
(*  License, or (at your option) any later version.  A special linking       *)
(*  exception to the GNU Lesser General Public License applies to this       *)
(*  library, see the COPYING file for more information.                      *)
(*****************************************************************************)

open Cudf

type cudf_parser
val from_in_channel : in_channel -> cudf_parser
val close : cudf_parser -> unit

(** Parse error. Arguments: line numnber and error message *)
exception Parse_error of int * string

(** {6 Full CUDF document parsing}

    "parse_*" functions offer plain syntax parsing, with no semantic
    interpretation of what is being parsed. "load_*" functions offer
    the latter, hence also checking for semantic constraints (such as
    the lack of key duplication).
*)

(** parse a CUDF document as a whole *)
val parse_cudf : cudf_parser -> cudf_doc

(** parse a CUDF document missing the request information item *)
val parse_packages : cudf_parser -> package list

val load_cudf : cudf_parser -> cudf
val load_universe : cudf_parser -> universe

(** {6 Item-by-item CUDF parsing} *)

(** parse the next information item (either a package description or a
    user request) from the given input channel. *)
val parse_item :
  cudf_parser -> [ `Package of package | `Request of request ]

(** {6 Low-level parsing functions} *)

(** Parse a file stanza (i.e., a RFC822-like stanza, with the notable
    simplification that all field/value pairs are one-liners). Strip
    any heading blanks lines leading to the first available
    field/value pair.
    
    @return an associative list mapping field name to field values*)
val parse_stanza : cudf_parser -> (string * string) list

