(package-initialize)

;; (setq straight-use-package-by-default t)
;; (defvar bootstrap-version)
;; (let ((bootstrap-file
;;        (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
;;       (bootstrap-version 5))
;;   (unless (file-exists-p bootstrap-file)
;;     (with-current-buffer
;;         (url-retrieve-synchronously
;;          "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
;;          'silent 'inhibit-cookies)
;;       (goto-char (point-max))
;;       (eval-print-last-sexp)))
;;   (load bootstrap-file nil 'nomessage))

(setq-default
 global-auto-revert-non-file-buffers t
 line-spacing 2
 )

(setq
 word-wrap t
 recentf-max-menu-items 50
 recentf-max-saved-items 300
 recentf-exclude '("/\\.git/.*\\'")
 initial-major-mode 'org-mode
 initial-scratch-message
 "#+title: Scratch Buffer\n\n"
 )

(add-hook 'before-save-hook 'time-stamp nil)

(add-to-list 'recentf-exclude "/elpa/.*\\'")
(add-to-list 'recentf-exclude "/tramp.*\\'")

(global-set-key (kbd "C-x C-o")
                (lambda ()
                  (interactive)
                  (flush-lines "^$")
                  )
                )

(use-package emacs
  :preface
  (defun my-reload-emacs ()
    "Reload the Emacs configuration"
    (interactive)
    (load-file "~/.emacs.d/init.el"))
  (defun revert-buffer-no-confirm ()
    "Revert buffer without confirmation."
    (interactive) (revert-buffer t t))
  :config
  (if init-file-debug
      (setq warning-minimum-level :debug)
    (setq warning-minimum-level :emergency))
  ;; Space around the windows
  ;; (fringe-mode '(0 . 0))
  (set-fringe-style '(8 . 8))
  ;; Terminal transparency
  (face-spec-set 'default
                 '((((type tty)) :background "unspecified-bg")))
  ;; Remember line number
  (if (fboundp #'save-place-mode)
      (save-place-mode +1)
    (setq-default save-place t))
  ;; Mimetypes
  (setq mailcap-user-mime-data
        '((type . "application/pdf")
          (viewer . pdf-view-mode)))
  :bind
  (("C-c R" . my-reload-emacs))
  ("<escape>" . keyboard-escape-quit) ; Make ESC close prompts
  ("C-c C-r" . revert-buffer-no-confirm)
  :hook (before-save . delete-trailing-whitespace)
  )

(use-package evil
  :init
(setq
 evil-want-keybinding nil
 evil-want-Y-yank-to-eol t
 evil-want-integration t
 evil-vsplit-window-right t
 evil-split-window-below t
 evil-search-module 'evil-search
 evil-want-C-i-jump nil
 )
:demand t
:bind (("<escape>" . keyboard-escape-quit))
:config
(evil-set-undo-system 'undo-redo)
(evil-set-leader 'normal (kbd "SPC"))

(defun my-evil-ex-substitute ()
    "Execute evil-ex with %s:"
    (interactive)
    (evil-ex "%s:"))
(evil-define-key 'normal 'global-map "S" 'my-evil-ex-substitute)
(evil-define-key 'normal 'global (kbd "<leader>wm") 'writegood-mode)
(evil-define-key 'normal 'global (kbd "<leader>a") 'evil-numbers/inc-at-pt)
(evil-define-key 'normal 'global (kbd "<leader>x") 'evil-numbers/dec-at-pt)

;; buffers
(evil-define-key 'normal 'global (kbd "<leader>bb") 'switch-to-buffer)
(evil-define-key 'normal 'global (kbd "<leader>bn") 'next-buffer)
(evil-define-key 'normal 'global (kbd "<leader>bp") 'previous-buffer)
(evil-define-key 'normal 'global (kbd "<leader>bk") 'kill-buffer)
(evil-define-key 'normal 'global (kbd "<leader>bx") 'scratch-buffer)
(evil-define-key 'normal 'global (kbd "<leader>bs") 'save-buffer)
(evil-define-key 'normal 'global (kbd "<leader>bl") 'list-buffers)

(evil-define-key 'normal 'global (kbd "<leader>ff") 'ido-find-file-in-dir)
(evil-define-key 'normal 'global (kbd "<leader>fr") 'recentf-open)
(evil-define-key 'normal 'global (kbd "<leader>fR") 'recentf-open-files)
(evil-define-key 'normal 'global (kbd "<leader>fo") 'find-file)

(evil-define-key 'normal 'global (kbd "<leader>wS") 'save-buffer)
(evil-define-key 'normal 'global (kbd "<leader>ws") 'evil-window-split)
(evil-define-key 'normal 'global (kbd "<leader>wv") 'split-window-horizontally)
(evil-define-key 'normal 'global (kbd "<leader>wk") 'evil-window-delete)
(evil-define-key 'normal 'global (kbd "<leader>wr") 'evil-window-rotate-downwards)
(evil-define-key 'normal 'global (kbd "<leader>wR") 'evil-window-rotate-upwards)

(evil-mode t))
(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode t)
  )
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))
(use-package evil-surround
  :config
  (global-evil-surround-mode t)
  :after evil)
(use-package evil-numbers
  :after evil)

(setq-default
 org-startup-indented t
 org-pretty-entities t
 org-use-sub-superscripts "{}"
 org-hide-emphasis-markers t
 org-startup-with-inline-images t
 org-image-actual-width '(300)
 )
(setq
 time-stamp-active t
 time-stamp-start "#\\+lastmod:[ \t]*"
 time-stamp-end "$"
 time-stamp-format "[%04Y-%02m-%02d %a]"
 org-clock-persist t
 org-clock-in-resume t
 org-clock-out-when-done t
 org-clock-report-include-clocking-task t
 )

(use-package org
  :ensure t
  :config
  (require 'org-clock)
  :bind
  (("C-c c" . org-capture)
   ("C-c l" . org-store-link)
   ("C-c a" . org-agenda))
  :custom
  (org-todo-keywords
   '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "IN PROGRESS(p)" "|" "DONE(d)" "CANCELLED(c)")))
  (org-export-with-drawers nil)
  (org-export-with-todo-keywords nil)
  (org-export-with-broken-links t)
  (org-export-with-toc nil)
  (org-export-with-smart-quotes t)
  (org-export-date-timestamp-format "%d %B %Y")
  (org-list-allow-alphabetical t)
  (org-capture-bookmark nil)
  (org-M-RET-may-split-line '((default . nil)))
  (org-capture-templates
   '(("f" "Fleeting note" item
      (file+headline org-default-notes-file "Notes")
      "- %?")
     ("t" "New task" entry
      (file+headline org-default-notes-file "Tasks")
      "* TODO %i%?")
     )))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)))
(use-package org-re-reveal
  :config
  (setq org-re-reveal-root "~/share/Teaching/reveal.js-master"
        ;; org-re-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js@4.6.1/"
        org-re-reveal-revealjs-version "4"
        org-re-reveal-default-frag-style "highlight-current-red"
        org-re-reveal-theme "beige"
        org-re-reveal-title-slide 'auto
        org-re-reveal-progress t
        org-re-reveal-center   t
        org-re-reveal-control  t
        org-re-reveal-keyboard t
        ;; org-re-reveal-width  1400
        ;; org-re-reveal-height 1200

	org-re-reveal-init-script (string-join '(
                                                 "hash: true"
                                                 "hashOneBasedIndex: true"
                                                 "respondToHashChanges: true"
                                                 "fragmentInURL: true"
                                                 "touch: true"
                                               "dependencies: [ {src: '../node_modules/revealjs-animated/dist/revealjs-animated.js', async: true} ]"
                                                 ;; "RevealChalkboard"
                                                 ;; "RevealCustomControls"
                                                 ;; "customcontrols: { controls: [ { icon: '<i class=\"fa fa-pen-square\"></i>'"
                                                 ;; "title: 'Toggle chalkboard (B)'"
                                                 ;; "action: 'RevealChalkboard.toggleChalkboard()'}"
                                                 ;; "{ icon: '<i class=\"fa fa-pen\"></i>'"
                                                 ;; "title: 'Toggle notes canvas (C)'"
                                                 ;; "action: 'RevealChalkboard.toggleNotesCanvas();'}]}"
                                                 )
                                               ", "
                                               )
        )
  (add-to-list 'org-re-reveal-plugin-config '(chalkboard "RevealChalkboard" "plugin/chalkboard/plugin.js"))
  )
(use-package org-download)
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/.emacs.d/org")
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))

(use-package man
:bind (
:map Man-mode-map
("q" . kill-this-buffer))
:custom
(Man-notify-method 'newframe))

(use-package outline
:hook ((prog-mode . outline-minor-mode))
:bind (:map outline-minor-mode-map
([C-tab] . outline-cycle)
("<backtab>" . outline-cycle-buffer)))

(use-package no-littering
  :init
  (setq user-emacs-directory "~/.cache/emacs")
  :config
  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
  )

(add-to-list 'default-frame-alist '(font . "CaskaydiaCove Nerd Font 14"))
(use-package nerd-icons)
(use-package olivetti
  ;; :hook ((text-mode         . olivetti-mode)
  ;;        (prog-mode         . olivetti-mode)
  ;;        (Info-mode         . olivetti-mode)
  ;;        (org-mode          . olivetti-mode)
  ;;        (nov-mode          . olivetti-mode)
  ;;        (markdown-mode     . olivetti-mode)
  ;;        (mu4e-view-mode    . olivetti-mode)
  ;;        (elfeed-show-mode  . olivetti-mode)
  ;;        (mu4e-compose-mode . olivetti-mode))
  :custom
  (olivetti-body-width 80)
  :delight " ⊗"
  :config
  (olivetti-mode t)
  ) ; Ⓐ ⊛

(use-package gruvbox-theme
    :config
    (load-theme 'gruvbox-dark-soft :no-confirm)
    )

(defun cycle-themes ()
  (interactive)
  (disable-theme 'catppuccin)
  (if (eq catppuccin-flavor 'latte)
      (setq catppuccin-flavor 'mocha)
    (if (eq catppuccin-flavor 'mocha)
        (setq catppuccin-flavor 'latte)
      )
    )
  (load-theme 'catppuccin :no-confirm)
  )

(use-package doom-modeline
  :config
  (doom-modeline-mode)
  :custom
  ;; Don't compact font caches during GC. Windows Laggy Issue
  (inhibit-compacting-font-caches t)
  (doom-modeline-major-mode-icon t)
  (doom-modeline-major-mode-color-icon t)
  (doom-modeline-icon (display-graphic-p))
  (doom-modeline-checker-simple-format t)
  (doom-line-numbers-style 'relative)
  (doom-modeline-buffer-file-name-style 'relative-to-project)
  (doom-modeline-buffer-modification-icon t)
  (doom-modeline-buffer-encoding nil)
  (doom-modeline-buffer-state-icon t)
  (doom-modeline-flycheck-icon t)
  (doom-modeline-height 35))

(use-package minions
  :delight " 𝛁"
  :hook (doom-modeline-mode . minions-mode)
  :config
  (minions-mode 1)
  (setq minions-mode-line-lighter "[+]"))

(use-package dashboard
  :bind (:map dashboard-mode-map
              ;; ("j" . nil)
              ;; ("k" . nil)
              ("n" . 'dashboard-next-line)
              ("p" . 'dashboard-previous-line)
              )
  :init (add-hook 'dashboard-mode-hook (lambda () (setq show-trailing-whitespace nil)))
  :custom
  (dashboard-set-navigator t)
  (dashboard-center-content t)
  (dashboard-set-file-icons t)
  (dashboard-set-heading-icons t)
  (dashboard-image-banner-max-height 250)
  (dashboard-banner-logo-title "[Ποσειδον 🔱 εδιτορ]") ; [Π Ο Σ Ε Ι Δ Ο Ν 🔱 Ε Δ Ι Τ Ο Ρ]
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-footer-icon (nerd-icons-codicon "nf-cod-calendar"
                                                  :height 1.1
                                                  :v-adjust -0.05
                                                  :face 'font-lock-keyword-face))
  (setq
   dashboard-projects-backend 'project-el
   dashboard-projects-switch-function 'counsel-projectile-switch-project-by-name
   dashboard-items '((recents        . 5)
                     (projects       . 2)
                     (bookmarks      . 5)
                     (agenda         . 3)
                     (registers      . 5)))
  :custom-face
  (dashboard-heading ((t (:foreground nil :weight bold)))) ; "#f1fa8c"
  )

(use-package ligature
  :config
  ;; Enables ligature checks globally in all buffers. You can also do it
  ;; per mode with `ligature-mode'.
  (global-ligature-mode t)
  ;; Enable the "www" ligature in every possible major mode
  (ligature-set-ligatures 't '("www"))
  ;; Enable traditional ligature support in eww-mode, if the
  ;; `variable-pitch' face supports it
  (ligature-set-ligatures 'eww-mode '("ff" "fi" "ffi"))
  ;; Enable all Cascadia Code ligatures in programming modes
  (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                                       ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                                       "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                                       "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                                       "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                                       "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                                       "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                                       "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                                       ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                                       "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                                       "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                                       "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                                       ;;                                        "\\\\" "://"))
                                       )
                          )
  )

(use-package org-modern
  :config
  (global-org-modern-mode)
  (menu-bar-mode 1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)

  ;; Add frame borders and window dividers
  (modify-all-frames-parameters
   '((right-divider-width . 40)
     (internal-border-width . 40)))
  (dolist (face '(window-divider
                  window-divider-first-pixel
                  window-divider-last-pixel))
    (face-spec-reset-face face)
    (set-face-foreground face (face-attribute 'default :background)))
  (set-face-background 'fringe (face-attribute 'default :background))

  (setq
   ;; Edit settings
   org-auto-align-tags nil
   org-tags-column 0
   org-catch-invisible-edits 'show-and-error
   org-special-ctrl-a/e t
   org-insert-heading-respect-content t

   ;; Org styling, hide markup etc.
   org-hide-emphasis-markers t
   org-pretty-entities t

   ;; Agenda styling
   org-agenda-tags-column 0
   org-agenda-block-separator ?─
   org-agenda-time-grid
   '((daily today require-timed)
     (800 1000 1200 1400 1600 1800 2000)
     " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
   org-agenda-current-time-string
   "◀── now ─────────────────────────────────────────────────")

  ;; Ellipsis styling
  (setq org-ellipsis "…")
  (set-face-attribute 'org-ellipsis nil :inherit 'default :box nil)
  )





(defun aorst/font-installed-p (font-name)
  "Check if font with FONT-NAME is available."
  (if (find-font (font-spec :name font-name))
      t
    nil))

(defun company-yasnippet-or-completion ()
  (interactive)
  (or (do-yas-expand)
      (company-complete-common)))

(defun check-expansion ()
  (save-excursion
    (if (looking-at "\\_>") t
      (backward-char 1)
      (if (looking-at "\\.") t
        (backward-char 1)
        (if (looking-at "::") t nil)))))

(defun do-yas-expand ()
  (let ((yas/fallback-behavior 'return-nil))
    (yas/expand)))

(defun tab-indent-or-complete ()
  (interactive)
  (if (minibufferp)
      (minibuffer-complete)
    (if (or (not yas/minor-mode)
            (null (do-yas-expand)))
        (if (check-expansion)
            (company-complete-common)
          (indent-for-tab-command)))))

(defun scramble-words-on-line ()
  "Scramble the words on the current line."
  (interactive)
  (let* ((line-start (line-beginning-position))
         (line-end (line-end-position))
         (line (buffer-substring-no-properties line-start line-end))
         (words (split-string line))
         (scrambled-words (shuffle-list words)))
    (delete-region line-start line-end)
    (insert (mapconcat 'identity scrambled-words " "))))

(defun shuffle-list (list)
  "Shuffle LIST randomly."
  (let ((len (length list))
        (result (copy-sequence list)))
    (dotimes (i len result)
      (let ((j (random (+ 1 i))))
        (cl-rotatef (nth i result) (nth j result))))))

(defun kill-other-buffers ()
  "Kill all buffers except the current one."
  (interactive)
  (let ((current-buffer (current-buffer)))
    (dolist (buffer (buffer-list))
      (unless (eq buffer current-buffer)
        (with-current-buffer buffer
          (when (and (buffer-file-name) (buffer-modified-p))
            (if (y-or-n-p (format "Buffer %s is modified; save it? " (buffer-name)))
                (save-buffer))))
        (kill-buffer buffer))))
  (message "Killed all other buffers"))

(use-package package
  :config
  (add-to-list 'package-archives
               '("melpa" . "https://melpa.org/packages/"))
  (add-to-list 'package-archives
               '("gnu" . "https://elpa.gnu.org/packages/"))
  (add-to-list 'package-archives
               '("nongnu" . "https://elpa.nongnu.org/nongnu/"))
  (add-to-list 'package-archives
               '("tromey" . "http://tromey.com/elpa/"))
  :custom
  (use-package-always-ensure t)
  (package-native-compile t)
  (warning-minimum-level :error))

(use-package ox-odt
  :ensure nil
  :config
  (add-to-list 'auto-mode-alist '("\\.\\(?:OD[CFIGPST]\\|od[cfigpst]\\)\\'" . doc-view-mode-maybe)))

(use-package persistent-scratch
  :init
  (persistent-scratch-setup-default)
  (persistent-scratch-autosave-mode)
  :hook
  (after-init . persistent-scratch-setup-default)
  :bind
  (("C-c w x" . scratch-buffer)))

(use-package corfu
  :custom
  (corfu-cycle t) ; cycle through suggestions
  (corfu-auto t) ; Auto completion
  (corfu-auto-prefix 2) ; Auto completion
  (corfu-auto-delay 0.0) ; time for autocompletion
  (corfu-quit-at-boundary 'separator) ; Not sure what this does
  (corfu-echo-documentation 0.25) ; Not sure what this does
  (corfu-preview-current 'insert) ; Do not preview current candidate
  (corfu-preselect-first nil)
  ;; Optionally use TAB for cycling, default is `corfu-complete`.
  :bind (:map corfu-map
              ("M-SPC" . corfu-insert-separator) ; Press M-SPC to insert a wildcard for the completion
              ;; ("RET" . nil) ; Leave my enter alone! lol
              ("TAB" . corfu-next)
              ([tab] . corfu-next) ; Why this and "TAB"?
              ("S-TAB" . corfu-previous)
              ([backtab] . corfu-previous) ; Again, why this?
              ;; ("SPC" . corfu-insert)
              ("S-<return>" . corfu-insert))
  :init
  (global-corfu-mode)
  ;; Save completion history for better sorting. Adds overhead but probably worth it, I think.
  (corfu-history-mode)
  (corfu-popupinfo-mode) ; Popup completion info
  :config
  (add-hook 'eshell-mode-hook
            (lambda () (setq-local corfu-quit-at-boundary t
                                   corfu-quit-no-match t
                                   corfu-auto nil)
              (corfu-mode))))

(use-package company
  :ensure t
  :custom
  (company-idle-delay 0.5)
  :bind
  (:map company-active-map
        ("C-j". company-select-next)
        ("C-k". company-select-previous)
        ("M-<". company-select-first)
        ("M-<". company-select-last))
  (:map company-mode-map
        ("<tab>". tab-indent-or-complete)
        ("TAB". tab-indent-or-complete)))

(use-package yasnippet
  :ensure t
  :config
  (yas-reload-all)
  (setq yas-snippet-dirs '("~/.emacs.d/snippets"))
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode)
  (yas-global-mode 1))

(use-package magit
  :config
  (setq magit-push-always-verify nil)
  (setq git-commit-summary-max-length 50)
  :bind ("C-x g" . magit-status)
  :delight)

(use-package git-gutter
  :delight
  :when window-system
  :defer t
  :bind (("C-x P" . git-gutter:popup-hunk)
         ("M-P" . git-gutter:previous-hunk)
         ("M-N" . git-gutter:next-hunk)
         ("C-c G" . git-gutter:popup-hunk))
  :hook ((prog-mode org-mode) . git-gutter-mode )
  :config
  (setq git-gutter:update-interval 2)
  ;; (setq git-gutter:modified-sign "†") ; ✘
  ;; (setq git-gutter:added-sign "†")
  ;; (setq git-gutter:deleted-sign "†")
  ;; (set-face-foreground 'git-gutter:added "Green")
  ;; (set-face-foreground 'git-gutter:modified "Gold")
  ;; (set-face-foreground 'git-gutter:deleted "Red")
  )

(use-package git-gutter-fringe
  :delight
  :after git-gutter
  :when window-system
  :defer t
  :init
  (require 'git-gutter-fringe)
  (when (fboundp 'define-fringe-bitmap)
    (define-fringe-bitmap 'git-gutter-fr:added
      [224 224 224 224 224 224 224 224 224 224 224 224 224
           224 224 224 224 224 224 224 224 224 224 224 224]
      nil nil 'center)
    (define-fringe-bitmap 'git-gutter-fr:modified
      [224 224 224 224 224 224 224 224 224 224 224 224 224
           224 224 224 224 224 224 224 224 224 224 224 224]
      nil nil 'center)
    (define-fringe-bitmap 'git-gutter-fr:deleted
      [0 0 0 0 0 0 0 0 0 0 0 0 0 128 192 224 240 248]
      nil nil 'center)))

(use-package git-timemachine)

(use-package which-key
  :defer t
  :delight
  :init (which-key-mode)
  (setq which-key-sort-order 'which-key-key-order-alpha
        which-key-idle 0.5
        which-key-idle-dely 50)
  (which-key-setup-minibuffer))

(use-package flycheck
  :hook (prog-mode . flycheck-mode)
  :bind (("M-g M-j" . flycheck-next-error)
         ("M-g M-k" . flycheck-previous-error)
         ("M-g M-l" . flycheck-list-errors))
  :config
  (setq flycheck-indication-mode 'right-fringe
        flycheck-check-syntax-automatically '(save mode-enabled))
  (global-flycheck-mode)
  ;; Small BitMap-Arrow
  (when (fboundp 'define-fringe-bitmap)
    (define-fringe-bitmap 'flycheck-fringe-bitmap-double-arrow
      [16 48 112 240 112 48 16] nil nil 'center))
  ;; Explanation-Mark !
  ;; (when window-system
  ;;   (define-fringe-bitmap 'flycheck-fringe-bitmap-double-arrow
  ;;     [0 24 24 24 24 24 24 0 0 24 24 0 0 0 0 0 0]))
  ;; BIG BitMap-Arrow
  ;; (when (fboundp 'define-fringe-bitmap)
  ;;   (define-fringe-bitmap 'flycheck-fringe-bitmap-double-arrow
  ;;     [0 0 0 0 0 4 12 28 60 124 252 124 60 28 12 4 0 0 0 0]))
  :custom-face
  (flycheck-warning ((t (:underline (:color "#fabd2f" :style line :position line)))))
  (flycheck-error ((t (:underline (:color "#fb4934" :style line :position line)))))
  (flycheck-info ((t (:underline (:color "#83a598" :style line :position line)))))
  :delight " ∰") ; "Ⓢ"
(use-package flycheck-popup-tip
  :config
  (add-hook 'flycheck-mode-hook 'flycheck-popup-tip-mode))

(use-package fancy-battery
  :config
  (setq fancy-battery-show-percentage t)
  (setq battery-update-interval 15)
  (if window-system
      (fancy-battery-mode)
    (display-battery-mode)))

(use-package highlight-indent-guides
  :custom
  (highlight-indent-guides-delay 0)
  (highlight-indent-guides-responsive t)
  (highlight-indent-guides-method 'character)
  ;; (highlight-indent-guides-auto-enabled t)
  ;; (highlight-indent-guides-character ?\┆) ;; Indent character samples: | ┆ ┊
  :commands highlight-indent-guides-mode
  :hook (prog-mode  . highlight-indent-guides-mode)
  :delight " ㄓ")

(use-package volatile-highlights
  :diminish
  :commands volatile-highlights-mode
  :hook (after-init . volatile-highlights-mode)
  :custom-face
  (vhl/default-face ((nil (:foreground "#FF3333" :background "BlanchedAlmond"))))) ; "#FFCDCD"

(use-package highlight-numbers
  :hook (prog-mode . highlight-numbers-mode))

(use-package rainbow-mode
  :defer t
  :hook ((prog-mode . rainbow-mode)
         (web-mode . rainbow-mode)
         (css-mode . rainbow-mode)))

(use-package rainbow-delimiters
  :config (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
  :delight)

(global-visual-line-mode t)
(save-place-mode t)
(global-auto-revert-mode t)
(display-line-numbers-mode t)
(recentf-mode t)
(savehist-mode t)

(add-to-list 'load-path "~/.config/emacs/writegood.el")
(load-file "~/.config/emacs/writegood.el")
(require 'writegood-mode)