-- Copyright (C) 2015 Tomoyuki Fujimori <moyu@dromozoa.com>
--
-- This file is part of dromozoa-chunk.
--
-- dromozoa-chunk is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- dromozoa-chunk is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with dromozoa-chunk.  If not, see <http://www.gnu.org/licenses/>.

local writer = require "dromozoa.chunk.writer"

writer(io.stdout):write_chunk {
  header = {
      endian = "<";
      major_version = 5;
      minor_version = 3;
      sizeof_int = 4;
      sizeof_size_t = 8;
      sizeof_instruction = 4;
      sizeof_integer = 8;
      sizeof_number = 8;
      number = "ieee754";
  };
  body = {
    source = "=stdin";
    line_defined = 0,
    last_line_defined = 0;
    num_params = 0;
    is_var_arg = true;
    max_stack_size = 3;
    code = {
      { "GETTABUP", 0, 0, -1 };
      { "CLOSURE", 1, 0 };
      { "LOADK", 2, -2 };
      { "CALL", 1, 2, 0 };
      { "RETURN", 0, 1 };
    };
    constants = {
      "print";
      42;
    };
    upvalues = {
      { in_stack = true; idx = 0; name = "_ENV"; }
    };
    protos = {
      {
        source = "=stdin";
        line_defined = 0;
        last_line_defined = 0;
        num_params = 1;
        is_var_arg = false;
        max_stack_size = 2;
        code = {
          { "GETUPVAL", 0, 0 };
          { "LOADK", 1, -1 };
          { "TAILCALL", 0, 2, 0 };
          { "TAILCALL", 0, 2, 0 };
          { "CALL", 0, 2, 0 };
          { "RETURN", 0, 1 };
        };
        constants = {
          17;
        };
        upvalues = {
          { in_stack = true; idx = 0; name = "p" };
        };
        protos = {};
        line_info = {};
        loc_vars = {};
      };
    };
    line_info = {};
    loc_vars = {};
  }
}
