{ pkgs, ... }:

let
  toLua = str: "lua << EOF\n${str}\nEOF\n";
  toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
in
{
  programs.neovim = {

    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    defaultEditor = true;

    extraPackages = with pkgs; [

      # Utils
      ripgrep
      lazygit

      # Docs
      glow

      # LSP
      nodePackages.typescript-language-server
      nodePackages.bash-language-server
      vscode-langservers-extracted
      llvmPackages_16.clang-unwrapped
      rust-analyzer
      gopls
      pyright
      lua-language-server
      nixd
      dockerfile-language-server-nodejs
      docker-compose-language-service
      marksman
      ltex-ls-plus
      yaml-language-server
      zls

      # formatters
      prettierd
      rustfmt
      nixpkgs-fmt
      stylua
      gofumpt
      gotools
      golines

      # linters
      eslint_d
      ruff
      golangci-lint
      typos

      # debug adapter
      codelldb
    ];

    plugins = with pkgs.vimPlugins; [

      {
        plugin = alpha-nvim;
        config = toLuaFile ./plugins/alpha.lua;
      }

      {
        plugin = nvim-tree-lua;
        config = toLuaFile ./plugins/nvim-tree.lua;
      }

      {
        plugin = aerial-nvim;
        config = toLuaFile ./plugins/aerial.lua;
      }

      {
        plugin = trouble-nvim;
        config = toLuaFile ./plugins/trouble.lua;
      }

      {
        plugin = which-key-nvim;
        config = toLua ''
          require("which-key").setup {}
        '';
      }

      {
        plugin = glow-nvim;
        config = ''
          ${toLua "require('glow').setup()"}

          map <C-p> :Glow<CR>
        '';
      }

      {
        plugin = telescope-nvim;
        config = toLuaFile ./plugins/telescope.lua;
      }
      telescope-fzf-native-nvim

      {
        plugin = nvim-treesitter.withAllGrammars;
        config = toLuaFile ./plugins/treesitter.lua;
      }
      nvim-treesitter-context

      {
        plugin = indent-blankline-nvim;
        config = toLua ''
          require("ibl").setup {
            indent = { char = "┊" },
            scope = {
                enabled = false
            }
          }
        '';
      }

      {
        plugin = nvim-autopairs;
        config = toLuaFile ./plugins/autopairs.lua;
      }

      {
        plugin = nvim-surround;
        config = toLua ''
          require("nvim-surround").setup {}
        '';
      }

      {
        plugin = substitute-nvim;
        config = toLuaFile ./plugins/substitute.lua;
      }

      nvim-web-devicons

      {
        plugin = onedark-nvim;
        config = toLua ''
          require('onedark').setup {
              style = 'warmer'
          }
          require('onedark').load()
        '';
      }

      {
        plugin = bufferline-nvim;
        config = toLuaFile ./plugins/bufferline.lua;
      }

      {
        plugin = lualine-nvim;
        config = toLuaFile ./plugins/lualine.lua;
      }

      {
        plugin = nvim-lspconfig;
        config = toLuaFile ./plugins/lspconfig.lua;
      }

      cmp-nvim-lsp
      cmp-nvim-lsp-signature-help
      cmp-buffer
      cmp-path
      cmp-nvim-lua
      cmp-spell
      cmp-dotenv
      lspkind-nvim
      {
        plugin = cmp-npm;
        config = toLua "require('cmp-npm').setup({})";
      }

      {
        plugin = nvim-cmp;
        config = toLuaFile ./plugins/cmp.lua;
      }
      cmp_luasnip

      {
        plugin = conform-nvim;
        config = toLuaFile ./plugins/conform.lua;
      }

      {
        plugin = nvim-lint;
        config = toLuaFile ./plugins/nvim-lint.lua;
      }

      {
        plugin = gitsigns-nvim;
        config = toLuaFile ./plugins/gitsigns.lua;
      }

      {
        plugin = crates-nvim;
        config = toLuaFile ./plugins/crates.lua;
      }

      luasnip

      {
        plugin = nvim-neoclip-lua;
        config = ''
          nnoremap fr <cmd>Telescope neoclip<cr>

          ${toLua "require('neoclip').setup {}"}
        '';
      }

      {
        plugin = nvim-scrollview;
        config = toLuaFile ./plugins/scrollview.lua;
      }

      # neotest
      {
        plugin = neotest;
        config = toLuaFile ./plugins/neotest.lua;
      }
      nvim-nio
      neotest-go
      neotest-jest

      {
        plugin = nvim-dap;
        config = toLuaFile ./plugins/dap.lua;
      }
      nvim-dap-ui

      {
        plugin = lazygit-nvim;
        config = toLua ''
          vim.keymap.set("n", "tg", "<cmd>LazyGit<cr>", { desc = "Toggle Git" })
        '';
      }

      {
        plugin = noice-nvim;
        config = toLua ''
          require("noice").setup()
        '';
      }

      {
        plugin = hardtime-nvim;
        config = toLua ''
          require("hardtime").setup()
        '';
      }

      {
        plugin = precognition-nvim;
        config = toLua ''
          require("precognition").setup({})
        '';
      }


      dressing-nvim

      open-browser-vim

      plantuml-previewer-vim
      plantuml-syntax

      rustaceanvim
    ];

    extraLuaConfig = ''

        -- Write lua config code here

        ${builtins.readFile ./options.lua}

        ${builtins.readFile ./filetypes.lua}

        ${builtins.readFile ./common.lua}
    '';
  };

}
