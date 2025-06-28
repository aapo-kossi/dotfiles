local function trim(s)
  return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

local function not_empty(a)
  return a and (a ~= '') and (a ~= nil)
end

local function parse_cpp_private_members(lines)
  local data_members = {}

  -- Iterate through each line provided in the input
  for _, line in ipairs(lines) do

    if not not_empty(line) then
      goto continue
    end

    local trimmed_line = trim(line)

    -- Skip empty lines or lines that are comments
    if (trimmed_line == "") or trimmed_line:match("^//") or trimmed_line:match("^/%*") then
      goto continue
    end

    -- Check if the line contains a semicolon, which indicates a declaration.
    -- Also, ensure it does NOT contain an opening parenthesis '(',
    -- which would indicate a method declaration or function pointer.
    if trimmed_line:match(";") and (not trimmed_line:match("%(")) then
      -- Remove the trailing semicolon for easier parsing
      local declaration = trim(trimmed_line:gsub(";", ""))

      local fields = vim.split(declaration, " ", true)
      local determined_name = fields[#fields]

      table.insert(data_members, determined_name)
    end
    ::continue:: -- Label for goto
  end

  return data_members
end

local function constructors(args, _, _)
  local classname = args[1][1]
  return {
    string.format("\t%s();", classname),
    string.format("\t%s(%s &&) = default;", classname, classname),
    string.format("\t%s(const %s &) = default;", classname, classname),
    string.format("\t%s &operator=(%s &&) = default;", classname, classname),
    string.format("\t%s &operator=(const %s &) = default;", classname, classname),
    string.format("\t~%s() = default;", classname),
  }
end

local function doxysnip(args, _, _)
  local nodes = {
    t({ "/**", " * " }),
    i(1, "A brief description"),
    t({ "", "" }),
  }

  -- Have private members
  local insert = 2
  local members = parse_cpp_private_members(args[1])

  -- Have at least 1 member
  if #members then
    vim.list_extend(nodes, { t({ " * ", "" }) })
  end

  for indx, arg in ipairs(members) do
    local inode = r(insert, "member_" .. arg, i(nil))
    vim.list_extend(
      nodes,
      { t({ " * @member " .. arg .. " " }), inode, t({ "", "" }) }
    )

    insert = insert + 1
  end

  -- -- Have template parameters
  if #args > 1 then
    for indx, arg in ipairs(vim.split(args[2][1], ", ", true)) do
      -- Get actual name parameter.
      local arg = vim.split(arg, " ", true)[2]
      if arg then
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

return {
  s("class-doc", {
    d(5, doxysnip, { 4 }),
    t({ "", "" }),
    t("class "),
    i(1, "my_class"),
    c(2, {
      t(""),
      sn(nil, {t(" : public "), r(1, "parentclass", i(nil, "parent"))}),
      sn(nil, {t(" : private "), r(1, "parentclass", i(nil, "parent")) }),
      sn(nil, {t(" : protected "), r(1, "parentclass" , i(nil, "parent"))}),
    }),
    t({ " {", "" }),
    t({ "private:", "" }),
    f(constructors, { 1 }),
    t({ "", "\t" }),
    i(3),
    t({ "", "" }),
    t({ "private:", "\t" }),
    i(4),
    t({ "", "" }),
    t({ "", "};" }),
  }),
  s("template-class-doc", {
    d(6, doxysnip, { 5, 1 }),
    t({ "", "" }),
    t("template <"),
    i(1, "class T"),
    t("> "),
    t("class "),
    i(2, "my_class"),
    c(3, {
      t(""),
      sn(nil, {t(" : public "), r(1, "parentclass", i(nil, "parent"))}),
      sn(nil, {t(" : private "), r(1, "parentclass", i(nil, "parent")) }),
      sn(nil, {t(" : protected "), r(1, "parentclass" , i(nil, "parent"))}),
    }),
    t({ " {", "\t" }),
    t({ "public:", "\t" }),
    i(4),
    t({ "", "" }),
    t({ "private:", "\t" }),
    i(5),
    t({ "", "};" }),
  }),
}
