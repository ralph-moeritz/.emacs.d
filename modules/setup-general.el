;; -*- mode: emacs-lisp; lexical-binding: t; -*-

(defun hide-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line endings."
  (interactive)
  (setq buffer-display-table (make-display-table))
  (aset buffer-display-table ?\^M []))

(defvar vanilla-config-funcs
  (list
   'setup-server
   'setup-lisp
   'setup-org-mode
   'setup-tramp
   'setup-nxml
   'global-set-vanilla-keys
   'global-set-vanilla-preferences
   )
  "List of functions to configure a vanilla emacs.")

(defun setup-server ()
  "Start server."
  (require 'server)
  (unless (server-running-p)
    (server-start)))

(defun setup-lisp ()
  (let ((slime-helper (expand-file-name "~/quicklisp/slime-helper.el")))
    (if (file-exists-p slime-helper)
        (load slime-helper)))
  (setq inferior-lisp-program "sbcl"))

(defun setup-tramp ()
  "Configure tramp for SSH."
  (setq tramp-default-method "plink")
  (setq explicit-shell-file-name "/bin/bash"))

(defun setup-nxml ()
  (add-to-list 'auto-mode-alist
               '("\\.\\(xaml\\|config\\)$" . nxml-mode) t))

(defun setup-org-mode ()
  (add-to-list 'auto-mode-alist
               '("\\.org$" . org-mode) t)
  (setq org-log-done t
        org-src-fontify-natively t
        org-insert-mode-line-in-empty-file t
        org-pretty-entities t)
  (add-hook 'org-mode-hook
            (lambda ()
              (local-set-key (kbd "\C-cl") 'org-store-link)
              (local-set-key (kbd "\C-ca") 'org-agenda))))

(defun global-set-vanilla-keys ()
  "Set global keyboard shortcuts that work in vanilla Emacs."
  (global-set-key (kbd "C-;") 'comment-or-uncomment-region)
  (global-set-key (kbd "C-M-z") 'multi-occur-in-this-mode))

(defun global-set-vanilla-preferences ()
  "A potpourri of preferences that work in vanilla emacs. Set globally."
  (setq inhibit-startup-message t)                          ;; no splash screen
  (setq-default indent-tabs-mode nil)                       ;; no tabs
  (set-face-attribute 'default nil :height 140)             ;; bigger font
  (setq column-number-mode t)                               ;; show column number in mode line
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-language-environment "UTF-8")
  (prefer-coding-system 'utf-8)                             ;; prefer UTF-8 everywhere
  (add-hook 'text-mode-hook 'turn-on-auto-fill)             ;; auto-fill in text-mode
  (put 'erase-buffer 'disabled nil)                         ;; enable erase-buffer
  (winner-mode 1)                                           ;; winner mode FTW
  (put 'upcase-region 'disabled nil)                        ;; enable upcase-region
  (setq-default fill-column 79)                             ;; fill at col 79
  (savehist-mode 1)                                         ;; minibuffer history
  (setq cua-auto-tabify-rectangles nil)                     ;; don't tabify after recangles
  (transient-mark-mode 1)                                   ;; no region when it is not highlighted
  (setq make-backup-files nil)                              ;; stop creating backup~ files
  )

(mapc 'funcall vanilla-config-funcs)

(provide 'setup-general)
