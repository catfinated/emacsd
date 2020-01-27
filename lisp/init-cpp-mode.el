(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

; style I want to use in c++ mode
(c-add-style "my-style" 
	     '("stroustrup"
	       (indent-tabs-mode . nil)        ; use spaces rather than tabs
	       (c-basic-offset . 4)            ; indent by four spaces
	       (c-offsets-alist . ((inline-open . 0)  ; custom indentation rules
                              (brace-list-open . 0)
                              (statement-case-open . +)))))

(defun my-c++-mode-hook ()
  (setq indent-tabs-mode nil)
  (c-set-style "my-style")
  (setq flycheck-clang-language-standard "c++11"))
  ; use my-style defined above
  ; (auto-fill-mode)         
  ;(c-toggle-auto-hungry-state 1))

(add-hook 'c++-mode-hook 'my-c++-mode-hook)

(provide 'init-cpp-mode)
