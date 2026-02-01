;;; init.el --- Emacs Configuration for C++, Rust, and Python Development
;;; Commentary:
;; A comprehensive development environment setup for modern C++, Rust, and Python

;;; Code:

;; ============================================================================
;; PACKAGE MANAGEMENT
;; ============================================================================

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; ============================================================================
;; GENERAL SETTINGS
;; ============================================================================

;; Basic UI cleanup
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode 1)
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

;; Better defaults
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(electric-pair-mode 1)
(show-paren-mode 1)
(global-auto-revert-mode 1)

;; Backup files in one place
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))
(setq auto-save-file-name-transforms `((".*" "~/.emacs.d/auto-save-list/" t)))
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

;; ============================================================================
;; THEME
;; ============================================================================

;; Install nerd-icons (required for doom-modeline icons in recent versions)
(use-package nerd-icons
  :if (display-graphic-p)
  :config
  ;; Run M-x nerd-icons-install-fonts if icons don't display properly
  (unless (find-font (font-spec :name "Symbols Nerd Font Mono"))
    (message "Nerd fonts not found. Run M-x nerd-icons-install-fonts")))

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-one t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 25))

;; ============================================================================
;; COMPLETION FRAMEWORK (IVY/COUNSEL/SWIPER)
;; ============================================================================

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line))
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
        ivy-count-format "(%d/%d) "))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         ("C-c g" . counsel-git)
         ("C-c j" . counsel-git-grep)
         ("C-c k" . counsel-ag))
  :config
  (counsel-mode 1))

(use-package swiper
  :bind ("C-s" . swiper))

;; ============================================================================
;; WHICH-KEY
;; ============================================================================

(use-package which-key
  :diminish
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.3))

;; ============================================================================
;; PROJECT MANAGEMENT
;; ============================================================================

(use-package projectile
  :diminish
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :config
  (projectile-mode 1)
  (setq projectile-project-search-path '("~/projects/"))
  (setq projectile-completion-system 'ivy))

(use-package counsel-projectile
  :after projectile
  :config
  (counsel-projectile-mode))

;; ============================================================================
;; TREEMACS - FILE TREE
;; ============================================================================

(use-package treemacs
  :bind
  (("C-c t t" . treemacs)
   ("C-c t 1" . treemacs-select-window))
  :config
  (setq treemacs-width 30))

(use-package treemacs-projectile
  :after (treemacs projectile))

(use-package treemacs-magit
  :after (treemacs magit))

;; ============================================================================
;; GIT INTEGRATION
;; ============================================================================

(use-package magit
  :bind ("C-x g" . magit-status)
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package diff-hl
  :config
  (global-diff-hl-mode)
  (diff-hl-flydiff-mode))

;; ============================================================================
;; COMPANY - AUTO-COMPLETION
;; ============================================================================

(use-package company
  :diminish
  :hook (after-init . global-company-mode)
  :bind (:map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous)
         ("TAB" . company-complete-selection))
  :config
  (setq company-idle-delay 0.1
        company-minimum-prefix-length 1
        company-selection-wrap-around t
        company-show-numbers t
        company-tooltip-align-annotations t
        company-backends '((company-capf company-files))
        company-dabbrev-downcase nil))

;; ============================================================================
;; FLYCHECK - SYNTAX CHECKING
;; ============================================================================

(use-package flycheck
  :diminish
  :hook (after-init . global-flycheck-mode)
  :config
  (setq flycheck-check-syntax-automatically '(save mode-enabled)))

;; ============================================================================
;; LSP MODE - LANGUAGE SERVER PROTOCOL
;; ============================================================================
(setenv "LSP_USE_PLISTS" "1")

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (setq lsp-enable-snippet t
        lsp-prefer-flymake nil
        lsp-headerline-breadcrumb-enable nil
        lsp-signature-auto-activate t
        lsp-signature-render-documentation t
        lsp-completion-provider :capf
        lsp-idle-delay 0.1
        read-process-output-max (* 1024 1024))

  :hook ((c-mode . lsp-deferred)
         (c++-mode . lsp-deferred)
         (rust-mode . lsp-deferred)
         (python-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration)))

(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point
        lsp-ui-doc-delay 0.5
        lsp-ui-sideline-enable t
        lsp-ui-sideline-show-diagnostics t
        lsp-ui-sideline-show-hover nil
        lsp-ui-sideline-show-code-actions t
        lsp-ui-peek-enable t))

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)

(use-package lsp-treemacs
  :commands lsp-treemacs-errors-list)

;; ============================================================================
;; DAP MODE - DEBUGGING
;; ============================================================================

(use-package dap-mode
  :after lsp-mode
  :config
  (dap-auto-configure-mode)
  (require 'dap-gdb-lldb)
  (require 'dap-python)
  :bind
  (("C-c d d" . dap-debug)
   ("C-c d l" . dap-debug-last)
   ("C-c d r" . dap-debug-recent)
   ("C-c d b" . dap-breakpoint-toggle)))

;; ============================================================================
;; YASNIPPET - SNIPPETS
;; ============================================================================

(use-package yasnippet
  :diminish yas-minor-mode
  :hook (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all))

(use-package yasnippet-snippets
  :after yasnippet)

;; ============================================================================
;; C/C++ CONFIGURATION
;; ============================================================================

(use-package cc-mode
  :ensure nil
  :mode ("\\.ipp\\'" . c++-mode)
  :config
  (setq c-basic-offset 4
        c-default-style "linux"))

(use-package modern-cpp-font-lock
  :hook (c++-mode . modern-c++-font-lock-mode))

(use-package cmake-mode
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'"))

(use-package cmake-font-lock
  :after cmake-mode
  :hook (cmake-mode . cmake-font-lock-activate))

;; Clangd configuration
(with-eval-after-load 'lsp-mode
  (setq lsp-clients-clangd-args '("--header-insertion-decorators"
                                   "--background-index"
                                   "--clang-tidy"
                                   "--completion-style=detailed"
                                   "--header-insertion=iwyu"
                                   "--pch-storage=memory")))

;; ============================================================================
;; RUST CONFIGURATION
;; ============================================================================

(use-package rust-mode
  :mode "\\.rs\\'"
  :config
  (setq rust-format-on-save t))

(use-package rustic
  :mode ("\\.rs\\'" . rustic-mode)
  :config
  (setq rustic-format-on-save t
        rustic-lsp-server 'rust-analyzer
        rustic-analyzer-command '("rust-analyzer"))
  :bind (:map rustic-mode-map
         ("C-c C-c l" . flycheck-list-errors)
         ("C-c C-c a" . lsp-execute-code-action)
         ("C-c C-c r" . lsp-rename)
         ("C-c C-c q" . lsp-workspace-restart)
         ("C-c C-c Q" . lsp-workspace-shutdown)
         ("C-c C-c s" . lsp-rust-analyzer-status)
         ("C-c C-c t" . rustic-cargo-test)
         ("C-c C-c c" . rustic-cargo-check)
         ("C-c C-c k" . rustic-cargo-clippy)
         ("C-c C-c b" . rustic-cargo-build)))

(use-package cargo
  :hook (rust-mode . cargo-minor-mode))

;; ============================================================================
;; PYTHON CONFIGURATION
;; ============================================================================

(use-package python-mode
  :ensure nil
  :mode ("\\.py\\'" . python-mode)
  :config
  (setq python-indent-offset 4))

;; Virtual environment management
(use-package pyvenv
  :config
  (pyvenv-mode 1))

;; Black formatter
(use-package blacken
  :hook (python-mode . blacken-mode)
  :config
  (setq blacken-line-length 88))

;; Python LSP configuration
(with-eval-after-load 'lsp-mode
  (setq lsp-pylsp-plugins-pydocstyle-enabled nil
        lsp-pylsp-plugins-pycodestyle-enabled nil
        lsp-pylsp-plugins-autopep8-enabled nil
        lsp-pylsp-plugins-yapf-enabled nil
        lsp-pylsp-plugins-flake8-enabled t
        lsp-pylsp-plugins-black-enabled t
        lsp-pylsp-plugins-mypy-enabled t))

;; Alternative: use pyright instead of pylsp
;; (setq lsp-pyright-python-executable-cmd "python3")

;; ============================================================================
;; ADDITIONAL UTILITIES
;; ============================================================================

;; Rainbow delimiters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Highlight TODO/FIXME
(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :config
  (setq hl-todo-keyword-faces
        '(("TODO"   . "#FF0000")
          ("FIXME"  . "#FF0000")
          ("DEBUG"  . "#A020F0")
          ("NOTE"   . "#1E90FF"))))

;; Multiple cursors
(use-package multiple-cursors
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))

;; Expand region
(use-package expand-region
  :bind ("C-=" . er/expand-region))

;; ============================================================================
;; PERFORMANCE OPTIMIZATIONS
;; ============================================================================

;; Increase garbage collection threshold
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))

;; LSP performance
(setq lsp-log-io t)
(setq lsp-enable-file-watchers nil)
(setq lsp-use-plists t)

;; ============================================================================
;; CUSTOM KEYBINDINGS
;; ============================================================================

;; Buffer management
(global-set-key (kbd "C-x k") 'kill-current-buffer)

;; Window navigation
(global-set-key (kbd "C-c w h") 'windmove-left)
(global-set-key (kbd "C-c w l") 'windmove-right)
(global-set-key (kbd "C-c w k") 'windmove-up)
(global-set-key (kbd "C-c w j") 'windmove-down)

;; Comment/uncomment
(global-set-key (kbd "C-c c") 'comment-or-uncomment-region)

;; ============================================================================
;; CUSTOM FUNCTIONS
;; ============================================================================

;; Reload configuration
(defun reload-init-file ()
  "Reload the init.el file."
  (interactive)
  (load-file user-init-file))

(global-set-key (kbd "C-c r") 'reload-init-file)

;; Format buffer
(defun format-buffer ()
  "Format the current buffer based on the major mode."
  (interactive)
  (save-excursion
    (cond
     ((derived-mode-p 'c++-mode 'c-mode)
      (lsp-format-buffer))
     ((derived-mode-p 'rust-mode 'rustic-mode)
      (rustic-format-buffer))
     ((derived-mode-p 'python-mode)
      (blacken-buffer))
     (t
      (indent-region (point-min) (point-max))))))

(global-set-key (kbd "C-c f") 'format-buffer)

;;; init.el ends here
