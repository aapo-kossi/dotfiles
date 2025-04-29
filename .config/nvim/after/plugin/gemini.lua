vim.system({"pass", "show", "gemini/174678912797"}, {}, function(result)
  key = result.stdout
  vim.schedule(function() vim.env.GEMINI_API_KEY = key:gsub('[\n\r]','') end)
end)


