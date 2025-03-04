return {
  'robitx/gp.nvim',
  enabled = vim.g.myconfig.ollama ~= nil,
  config = function()
    require('gp').setup {
      log_sensitive = true,
      providers = {
        ollama = {
          disable = false,
          endpoint = vim.g.myconfig.ollama.url,
          secret = 'ollama',
        },
        openai = {
          disable = true,
        },
      },
      agents = {
        {
          name = 'ChatOllamaLlama3.1-8B',
          disable = true,
        },
        {
          name = 'CodeOllamaLlama3.1-8B',
          disable = true,
        },
        {
          name = 'ChatOllamaLlama3.2',
          provider = 'ollama',
          chat = true,
          command = false,
          model = {
            min_p = 0.05,
            model = 'llama3.2',
            temperature = 0.6,
            top_p = 1,
          },
          system_prompt = 'You are a general AI assistant.',
        },
        {
          name = 'CodeOllamaLlama3.2',
          provider = 'ollama',
          chat = false,
          command = true,
          model = {
            min_p = 0.05,
            model = 'llama3.2',
            temperature = 0.4,
            top_p = 1,
          },
          system_prompt = 'You are an AI working as a code editor.',
        },
      },
    }
  end,
}
