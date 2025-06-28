local function not_empty(a)
  return a and (a ~= '') and (a ~= nil)
end

local function doxysnip(args, _, _)
  local nodes = {
    t({ "/**", " * " }),
    i(1, "A brief description"),
    t({ "", "" }),
  }

  -- Have at least 1 parameter
  if string.find(args[2][1], ", ") then
    vim.list_extend(nodes, { t({ " * ", "" }) })
  end

  local insert = 2
  for indx, arg in ipairs(vim.split(args[2][1], ", ", true)) do
    -- Get actual name parameter.
    local qualis_and_arg = vim.split(arg, " ", true)
    local arg = qualis_and_arg[#qualis_and_arg]
    if not_empty(arg) then
      local inode
      inode = r(insert, "arg" .. arg, i(nil))
      vim.list_extend(
        nodes,
        { t({ " * @param " .. arg .. " " }), inode, t({ "", "" }) }
      )

      insert = insert + 1
    end
  end

  -- Have a return value
  if args[1][1] ~= "void" then
    local inode = r(insert, "return", i(nil))

    vim.list_extend(
      nodes,
      { t({ " * ", " * @return " }), inode, t({ "", "" }) }
    )
    insert = insert + 1
  end

  -- Have template parameters
  if #args > 2 then
    for indx, arg in ipairs(vim.split(args[3][1], ", ", true)) do
      -- Get actual name parameter.
      local arg = vim.split(arg, " ", true)[2]
      if not_empty(arg) then
        local inode
        inode = r(insert, "targ" .. arg, i(nil))
        vim.list_extend(
          nodes,
          { t({ " * @tparam " .. arg .. " " }), inode, t({ "", "" }) }
        )

        insert = insert + 1
      end
    end
  end

  vim.list_extend(nodes, { t({ " */" }) })

  return sn(nil, nodes)
end

-- Recursive builder of factory function cases using branches or switches
local function factory_case(_, _, _, index, mode)
  if mode == "if" then
    return sn(nil, {
      t({ "", "\t" }),
      t("if (type == \""), i(1, "Key" .. index), t("\") {"),
      t({ "", "\t\treturn std::make_unique<" }), i(2, "Derived" .. index), t(">();"),
      t({ "", "\t}" }),
      c(3, {
        t(""),
        d(1, factory_case, {}, { user_args = { index + 1, mode } }),
      }),
    })
  elseif mode == "switch" then
    return sn(nil, {
      t({ "", "\t" }),
      t("case '"), i(1, string.char(64 + index)), t("':"),
      t({ "", "\t\treturn std::make_unique<" }), i(2, "Derived" .. index), t(">();"),
      c(3, {
        t(""),
        d(1, factory_case, {}, { user_args = { index + 1, mode } }),
      }),
    })
  else
    return sn(nil, {})
  end
end

return {
  s("trig", t("loaded!!")),
  s("fn-doc", {
    d(5, doxysnip, { 1, 3 }),
    t({ "", "" }),
    i(1, "void"),
    t(" "),
    i(2, "myFunc"),
    t("("),
    i(3),
    t(")"),
    c(4, {
      t(""),
      t(" noexcept"),
    }),
    t({ " {", "\t" }),
    i(6),
    t({ "", "}" }),
  }),
  s("templ-fn-doc", {
    d(6, doxysnip, { 2, 4, 1 }),
    t({ "", "" }),
    t("template <"),
    i(1, "class T"),
    t("> "),
    i(2, "void"),
    t(" "),
    i(3, "myFunc"),
    t("("),
    i(4),
    t(")"),
    c(5, {
      t(""),
      t(" noexcept"),
    }),
    t({ " {", "\t" }),
    i(7),
    t({ "", "}" }),
  }),

  s("factory", {
    t("std::unique_ptr<"),
    i(1, "Base"),
    t("> create_"),
    f(function(args) return args[1][1]:lower() end, { 1 }),
    t("(const std::string& type) {"),
    c(2, {
      -- if-else chain
      sn(nil, {
        d(1, factory_case, {}, { user_args = { 1, "if" } }),
      }),
      -- switch statement
      sn(nil, {
        t({ "", "\tswitch(type[0]) {" }),
        d(1, factory_case, {}, { user_args = { 1, "switch" } }),
        t({ "", "\t}" }),
      }),
    }),
    t({ "", "\tthrow std::runtime_error(\"Unknown type: \" + type);", "}" }),
  }),

}
