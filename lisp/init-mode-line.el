(require-package 'smart-mode-line)
(require-package 'smart-mode-line-powerline-theme)

(setq sml/no-confirm-load-theme t)
(setq sml/theme 'powerline)
(sml/setup)

(provide 'init-mode-line)
