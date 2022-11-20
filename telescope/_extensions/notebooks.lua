-- check dependencies
local telescope_ok, _ = pcall(require, 'telescope')
local plenary_ok, _ = pcall(require, 'plenary')
if not plenary_ok then
  print('Plenary required for notes-telescope to work')
  return
end
if not telescope_ok then
  print('Telescope required for notes-telescope to work')
  return
end

local telescope = require('telescope')
-- local actions = require('telescope.actions')
-- local state = require('telescope.actions.state')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local sorters = require('telescope.sorters')
local themes = require('telescope.themes')
local Path = require('plenary.path')
local scandir = require('plenary.scandir')

local notebooksDir = M.config.notebooks

local function get_notebooks()
  local dir_list = scandir.scan_dir(notebooksDir, { hidden = false, depth = 1 })

  local notebook_list = {}

  for notebook in dir_list do
    local note_index = notebook .. 'index.md'
    local exists = Path:new(note_index):exists()

    if exists then
      table.insert(notebook_list, {
        index = note_index,
        name = notebook,
        dir = notebook,
      })
    end
  end

  return notebook_list
end

local function select_notebook(opts)
  -- Use dropdown theme by default
  opts = themes.get_dropdown(opts)

  pickers
    .new(opts, {
      prompt_title = '-- Notebooks --',
      initial_mode = 'normal',
      finder = finders.new_table({
        results = get_notebooks(),
        entry_maker = function(entry)
          return {
            value = entry.index,
            display = entry.name,
            ordinal = entry.name,
          }
        end,
      }),
      sorter = sorters.get_fzy_sorter(),
    })
    :find()
end

return telescope.register_extension({
  exports = {
    notebooks = select_notebook,
  },
})
