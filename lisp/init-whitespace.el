(setq indent-tabs-mode nil)
(require-package 'whitespace-cleanup-mode)
(global-whitespace-cleanup-mode t)

(global-set-key [remap just-one-space] 'cycle-spacing)

(provide 'init-whitespace)
