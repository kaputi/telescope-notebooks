
M = {}

M.config = {
  notebooks_dir = '~/notebooks'
}

M.setup = function (values)
  if values.notebooks_dir then
    M.config.notebooks_dir = values.notebooks_dir
  end


  -- setmetatable(M.config,{__index = vim.tbl.tbl_extend('force', defaults,values)})
end

return M
