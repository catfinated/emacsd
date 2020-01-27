(setq auto-mode-alist
      (append '(("SConstruct\\'" . python-mode)
		("SConscript\\'" . python-mode))
              auto-mode-alist))

(require-package 'pip-requirements)

(add-hook 'python-mode-hook '(lambda ()
 (setq indent-tabs-mode nil)
 (setq python-guess-indent nil)
 (setq python-indent 4)))

(provide 'init-python-mode)
