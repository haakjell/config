## Neovim requirements

Neovim config for Linux/WSL (Debian). Neovim config lives in `~/git/config/nvim` and is
prepended to the runtimepath in `init.vim`.

### Required

| Program         | Why                                                                    | Install                            |
| --------------- | ---------------------------------------------------------------------- | ---------------------------------- |
| Neovim (0.11+)  | Required by nvim-treesitter `main` and string `g:clipboard`            | Release tarball from GitHub        |
| git             | lazy.nvim bootstrap, gitsigns, git-conflict                            | `sudo apt install git`             |
| curl, tar       | nvim-treesitter downloads parsers                                      | `sudo apt install curl tar`        |
| C compiler      | nvim-treesitter compiles parsers                                       | `sudo apt install build-essential` |
| tree-sitter CLI | nvim-treesitter `main` builds parsers with it (apt version is too old) | see below                          |

```bash
mkdir -p ~/.local/bin
curl -L https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz \
  | gunzip > ~/.local/bin/tree-sitter
chmod +x ~/.local/bin/tree-sitter
```

### WSL only

| Program       | Why                                                       | Install                  |
| ------------- | --------------------------------------------------------- | ------------------------ |
| win32yank.exe | Windows clipboard, converts CRLF to LF on paste (no `^M`) | see below                |
| unzip         | To unpack win32yank                                       | `sudo apt install unzip` |

```bash
curl -L https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip -o /tmp/win32yank.zip
unzip -o /tmp/win32yank.zip win32yank.exe -d ~/.local/bin
chmod +x ~/.local/bin/win32yank.exe
```

### Terminal

- A Nerd Font set as the terminal font (icons in nvim-web-devicons, oil, nvim-tree).
  On WSL, set this in Windows Terminal.

### Check

- `~/.local/bin` must be on `PATH`.
- After first start: `:checkhealth nvim-treesitter` and `:checkhealth provider`.

