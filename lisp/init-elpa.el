(require 'package)

;;; Add package repos
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
;(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

(defun sanityinc/package-maybe-enable-signatures ()
  (setq package-check-signature (when (executable-find "gpg") 'allow-unsigned)))

(sanityinc/package-maybe-enable-signatures)
(after-load 'init-exec-path
	    (sanityinc/package-maybe-enable-signatures))


(defun require-package (package &optional min-version no-refresh)
  "Install given PACKAGE, optionally requiring MIN-VERSION.
If NO-REFRESH is non-nil, the available package lists will not be
re-downloaded in order to locate PACKAGE."
  (if (package-installed-p package min-version)
      t
    ;;  if find package in association list or no-refresh
    (if (or (assoc package package-archive-contents) no-refresh)
	;; if package-selected-packages is not void
	(if (boundp 'package-selected-packages)
	    ;; Record this as a package the user installed explicitly
	    (package-install package nil)
	  (package-install package))
      ;; eval each expression in sequeence and return result of last one
      (progn
	(package-refresh-contents)
	(require-package package min-version t)))))


(defun maybe-require-package (package &optional min-version no-refresh)
  "Try to install PACKAGE, and return non-nil if successful.
In the event of failure, return nil and print a warning message.
Optionally require MIN-VERSION.  If NO-REFRESH is non-nil, the
available package lists will not be re-downloaded in order to
locate PACKAGE."
  (condition-case err
      (require-package package min-version no-refresh)
    (error
     (message "Couldn't install package `%s': %S" package err)
     nil)))

;;; Fire up package.el
(setq package-enable-at-startup nil)
(package-initialize)

(provide 'init-elpa)
