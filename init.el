
(let ((minver "24.1"))
  (when (version<= emacs-version "24.1")
    (error "Your Emacs is too old you whoreson! min version v%s" minver)))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;;----------------------------------------------------------
;; Save customizations somewhere other than here or ~/.emacs
;;----------------------------------------------------------
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(tool-bar-mode -1)
(scroll-bar-mode -1)
;;(setq inhibit-startup-message t)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 3)
(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)

(require 'init-utils)
(require 'init-elpa)
(require 'init-exec-path)
(require 'init-mode-line)
(require 'init-themes)
(require 'init-python-mode)
(require 'init-cpp-mode)
(require 'init-rust)
(require 'init-compile)
(require 'init-flycheck)
(require 'init-ido)
(require 'init-whitespace)
(require 'init-git)
(require 'init-glsl)
(require 'init-yaml)

(when (file-exists-p custom-file)
  (load custom-file))

(provide 'init)
