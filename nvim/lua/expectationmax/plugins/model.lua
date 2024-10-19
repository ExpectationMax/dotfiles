local function input_if_selection(input, context)
  return context.selection and input or ''
end

local function build_review_prompt(diff)
    local template = [[
Please perform a code review of the following diff (produced by `git diff` on my code), and provide suggestions for improvement:

```
%s
```
Please prioritize the response by impact to the code, and please split the suggestions into three categories:
1. Suggestions that pertain to likely runtime bugs or errors.
2. Suggestions that pertain to likely logic bugs or errors.
3. Suggestions that pertain to likely style bugs or errors.

If possible, please also provide a suggested fix to the identified issue.  If you are unable to provide a suggested fix, please provide a reason why.

The format should look like:

```
1. Likely runtime bugs:
- Some suggestion...
- Another...

2. Likely logic bugs:
- Suggestion 1
- Suggestion 2
- Suggestion 3

3. Likely style bugs:
- Suggestion 1
- Suggestion 2
- Suggestion 3
```

For each relevant code snippet, please provide context about where the suggestion is relevant (e.g., `path/file.py:30`); in addition, if a code snippet would be helpful, please provide a code snippet showing the fix.
]]
    return string.format(template, diff)
end

local function git_diff(input, context)

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

local function codellama_chat(messages, config)
      print(string.format("config.system: %s", config.system))
      local prompt = "[INST] " .. (config.system and "<<SYS>>\n" .. config.system .. "\n<</SYS>>\n\n" or "")

      for index, msg in ipairs(messages) do
        prompt = prompt
          .. ((msg.role == "user" and index ~= 1) and '[INST] ' or '')
          .. msg.content
          .. (msg.role == "user" and ' [/INST]\n' or '\n')
      end

      return {
        prompt = prompt,
        raw = true,
      }
end

local function get_typical_parent()
    vim.fn.system("git rev-parse --verify main")
    if vim.v.shell_error == 0 then
        return "main"
    else
        return "master"
    end
end

return {
    "gsuuon/model.nvim",
    enabled=false,
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
                ["codellama"] = {
                    provider = ollama,
                    system = "You are a helpful programming assistant.",
                    params = {
                        model = 'codellama',
                        stop = '</s>',
                    },
                    create = input_if_selection,
                    run = codellama_chat
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

                },
                ["check_branch_form"] = {
                    provider = ollama,
                    -- system = "You are a helpful programming assistant. Examine the below diff and suggest fixes for docstring inconsistencies and typos. Do not try to verify correctness or test coverage.",
                    params = {
                        --model = 'codellama:13b-instruct',
                        model = 'mistral:instruct',
                        stop = "</s>"
                    },
                    mode = mode.BUFFER,
                    builder = function()
                        local git_diff = vim.fn.system({"git", "diff", "-B", "-M", "-C", "--merge-base", get_typical_parent(), "HEAD"})
                        if not git_diff:match('^diff') then
                          error('Git error:\n' .. git_diff)
                        end

                        prompt = "<s>[INST] "..build_review_prompt(git_diff).."[/INST] "

                        return {
                            prompt=prompt,
                            raw=true,
                            stops = {"</s>", "[/PYTHON]"}
                        }
                    end,
                },
            },
        })
    end
}
