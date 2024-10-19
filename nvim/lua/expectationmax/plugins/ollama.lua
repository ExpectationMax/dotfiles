response_format = "Respond EXACTLY in this format:\n```$ftype\n<your code>\n```"
response_format_replace = "Respond EXACTLY in this format keeping the same indentation as the input:\n```$ftype\n<your code>\n```"
selection = "```$ftype\n$sel\n```"

return {
  "nomnivore/ollama.nvim",
  enabled=false,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },

  -- All the user commands added by the plugin
  cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },

  keys = {
    {
      "<leader>od",
      ":<c-u>lua require('ollama').prompt('docstring')<cr>",  
      desc = "Docstring",
      mode = { "v" },
    },
    {
      "<leader>op",
      ":<c-u>lua require('ollama').prompt()<cr>",
      desc = "Prompt",
      mode = { "n", "v" },
    },
    {
      "<leader>om",
      ":<c-u>lua require('ollama').prompt('Modify_Code')<cr>",
      desc = "Modify",
      mode = { "n", "v" },
    },
    {
      "<leader>og",
      ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
      desc = "Generate Code",
      mode = { "n", "v" },
    },
  },

  opts = {
    model = "llama3",
    -- your configuration overrides
    prompts = {
        docstring = {
            prompt = "Adapt the docstring of this python code to follow googles docstring convention. "
                .. response_format_replace .. "\n\n" .. selection,
            action = "display_replace"
        },
    }
  }
}
