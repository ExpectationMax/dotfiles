local function input_if_selection(input, context)
  return context.selection and input or ''
end

local function mistral_chat(messages, config)
      local prompt = '<s>[INST]' .. config.system

      for index, msg in ipairs(messages) do
        prompt = prompt
          .. ((msg.role == "user" and index ~= 1) and '[INST]' or '')
          .. msg.content
          .. (msg.role == "user" and '[/INST]\n' or '\n')
      end

      return {
        prompt = prompt,
      }
end

return {
    "gsuuon/model.nvim",
    -- Don't need these if lazy = false
    cmd = { 'M', 'Model', 'Mchat', 'Mselect', 'Mdelete', 'Mcancel', 'Mshow', 'MCadd', 'MCremove', 'MCclear', 'MCpaste'},
    init = function()
      vim.filetype.add({
        extension = {
          mchat = 'mchat',
        }
      })
    end,
    ft = 'mchat',
    config = function ()
        local ollama = require('model.providers.ollama')
        local mode = require('model').mode
        require("model").setup({
              default_prompt = {
                provider = ollama,
                builder = function(input)
                    return {
                        raw = false,
                        system = 'You are helpful assistant.',
                        prompt = input,
                    }
                end
            },
            chats = {
                 ['mistral'] = {
                system = "You are an intelligent assistant. ",
                provider = ollama,
                params = {
                    model = 'mistral'
                },
                create = input_if_selection,
                run = mistral_chat,
              },
            },
            prompts = {
                ["commit"] = {
                    provider = ollama,
                    params = {
                        model = 'mistral',
                    },
                    mode = mode.INSERT,
                    builder = function()
                        local git_diff = vim.fn.system {'git', 'diff', '--staged'}
                        return {
                            prompt = '<s>[INST]You are an expert programmer. Write a terse commit message according to the Conventional Commits specification. Try to stay below 80 characters for the first line. Do not halucinate any PR or issue references. Git diff: \n```\n' .. git_diff .. '\n```[/INST]'
                        }
                    end,

                }
            },
        })
    end
}
