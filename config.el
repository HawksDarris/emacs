(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

  ;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

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
    (setq visible-bell t)
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
    ;; (setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))
(setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
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
 evil-want-C-u-scroll t
 evil-want-C-i-jump nil
 evil-want-Y-yank-to-eol t
 evil-want-integration t
 evil-vsplit-window-right t
 evil-split-window-below t
 evil-search-module 'evil-search
 )
:demand t
:bind (("<escape>" . keyboard-escape-quit))
:config
(evil-mode t)
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
(evil-define-key 'normal 'global (kbd "<leader>,") 'org-timestamp-inactive)

;; buffers
(evil-define-key 'normal 'global (kbd "<leader>bb") 'switch-to-buffer)
(evil-define-key 'normal 'global (kbd "<leader>bd") 'dashboard-refresh-buffer)
(evil-define-key 'normal 'global (kbd "<leader>bk") 'kill-buffer)
(evil-define-key 'normal 'global (kbd "<leader>bx") 'scratch-buffer)
(evil-define-key 'normal 'global (kbd "<leader>bs") 'save-buffer)

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

)

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
  :after evil
  :config
  (global-evil-surround-mode t)
  :after evil)
(use-package evil-numbers
  :after evil)

(use-package org
  :ensure t
  :init
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
   time-stamp-format "[%04Y-%02m-%02d %:A]"
   org-clock-persist t
   org-clock-in-resume t
   org-clock-out-when-done t
   org-clock-report-include-clocking-task t
   org-html-validation-link nil
   org-log-done 'time
   org-log-repeat 'time
   org-archive-location "~/org/archive.org::"
   org-agenda-files '("~/org/")
   )
  :config
  (require 'org-clock)
  (setq org-ellipsis " ▾")
(setq org-agenda-start-with-log-mode t)
(setq org-log-done 'time)
(setq org-log-into-drawer t)
(require 'org-habit)
(add-to-list 'org-modules 'org-habit)
(setq org-habit-graph-column 60)
;; Save Org buffers after refiling!
(advice-add 'org-refile :after 'org-save-all-org-buffers)


  ;; Agenda styling
  (setq
   org-agenda-tags-column 0
   org-agenda-block-separator ?─
   org-agenda-time-grid
   '((daily today require-timed)
     (800 1000 1200 1400 1600 1800 2000)
     " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
   org-agenda-current-time-string ""
   org-agenda-hide-tags-regexp ".*"
   )

  (add-hook 'org-agenda-mode-hook (lambda () (olivetti-mode)))

  (setq org-agenda-custom-commands
        '(("c" "Classes this Week"
           ((agenda "" ((org-agenda-span '7)              ;; Show 7-day agenda
                        (org-agenda-start-day "+0")       ;; Start from today
                        (org-agenda-overriding-header "Classes this Week")
                        (org-agenda-skip-function         ;; Skip entries without certain tags
                         '(org-agenda-skip-entry-if 'notregexp ":evenweeks:\\|:oddweeks:\\|:hades:"))))))
          ("C" "Classes this Fortnight"
           ((agenda "" ((org-agenda-span '14)              ;; Show 14-day agenda
                        (org-agenda-start-day "+0")       ;; Start from today
                        (org-agenda-overriding-header "Classes in the Next Two Weeks")
                        (org-agenda-skip-function         ;; Skip entries without certain tags
                         '(org-agenda-skip-entry-if 'notregexp ":evenweeks:\\|:oddweeks:\\|:hades:"))))))

          ("d" agenda "Today's Deadlines"
           (
            (org-agenda-span 'day)
            (org-agenda-skip-function '(org-agenda-skip-deadline-if-not-today))
            (org-agenda-entry-types '(:deadline))
            (org-agenda-overriding-header "Today's Deadlines ")
            ))
	  ("t" "Today's tasks"
           ((agenda "" (
			(org-agenda-span 'day)
                        (org-deadline-warning-days 0)
                        (org-scheduled-past-days 0)
			(org-agenda-overriding-header "Today's Tasks")
			))))
          ))

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)))
  :bind
  (("C-c c" . org-capture)
   ("C-c l" . org-store-link)
   ("C-c a" . org-agenda)
   ("C-c ," . org-timestamp-inactive)
   )
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
     ("a" "Agenda notes" entry
      (file+datetree "~/org/notes.org")
      "* %U Agenda notes for %^{Agenda item} \n%?"
      :clock-in t :clock-resume t :clock-out t)
     ))
  (efs/org-font-setup)
  )

(use-package org-super-agenda
  :config
  (setq org-super-agenda-groups
      '(;; Each group has an implicit boolean OR operator between its selectors
        (:name "! Overdue " ; optional section name
               :scheduled past
               :order 2
               :face 'error
                 )
          (:name "Events "
               :order 2
               )
          (:name "Teaching "
               :order 2
               :and(:not (:tag "business"))
               )
        )
	))

(use-package org-download)

(use-package org-fancy-priorities
  :diminish
  :ensure t
  :hook (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '("🅰" "🅱" "🅲" "🅳" "🅴")))

(use-package org-pretty-tags
  :diminish org-pretty-tags-mode
  :ensure t
  :config
  (setq org-pretty-tags-surrogate-strings
        '(("work"  . "⚒")))

  (org-pretty-tags-global-mode))

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/org/roam")
  :bind (
	   ("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today)
	     )
  :config
  (setq org-roam-graph-executable
	(executable-find "neato"))
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (setq org-roam-completion-system 'ido)
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol)
  (evil-define-key 'normal 'global (kbd "<leader>rb" ) 'org-roam-buffer-toggle)
  (evil-define-key 'normal 'global (kbd "<leader>rf" ) 'org-roam-node-find)
  (evil-define-key 'normal 'global (kbd "<leader>rg" ) 'org-roam-graph)
  (evil-define-key 'normal 'global (kbd "<leader>ri" ) 'org-roam-node-insert)
  (evil-define-key 'normal 'global (kbd "<leader>rc" ) 'org-roam-capture)
  (evil-define-key 'normal 'global (kbd "<leader>rt" ) 'org-roam-tag-add)
  ;; Dailies
  (evil-define-key 'normal 'global (kbd "<leader>dj" ) 'org-roam-dailies-capture-today)
  )

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

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(use-package notmuch
  )

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

(add-to-list 'default-frame-alist '(alpha-background . 80))
(defvar efs/default-font-size 180)
(defvar efs/default-variable-font-size 180)
  (defun efs/org-font-setup ()
    ;; Replace list hyphen with dot
    (font-lock-add-keywords 'org-mode
                            '(("^ *\\([-]\\) "
                               (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

    ;; Set faces for heading levels
    (dolist (face '((org-level-1 . 1.2)
                    (org-level-2 . 1.1)
                    (org-level-3 . 1.05)
                    (org-level-4 . 1.0)
                    (org-level-5 . 1.1)
                    (org-level-6 . 1.1)
                    (org-level-7 . 1.1)
                    (org-level-8 . 1.1)))
      (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

    ;; Ensure that anything that should be fixed-pitch in Org files appears that way
    (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
    (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

  (add-to-list 'default-frame-alist '(font . "CaskaydiaCove Nerd Font 14"))

  (set-face-attribute 'default nil :font "FiraCode Nerd Font Mono Ret" :height efs/default-font-size)

  ;; Set the fixed pitch face
  (set-face-attribute 'fixed-pitch nil :font "FiraCode Nerd Font Mono Ret" :height efs/default-font-size)

  ;; Set the variable pitch face
  ;; (set-face-attribute 'variable-pitch nil :font "Cantarell" :height efs/default-variable-font-size :weight 'regular)
  (set-face-attribute 'variable-pitch nil :font "NotoSansM Nerd Font" :height efs/default-font-size)

  (use-package nerd-icons)

  (use-package olivetti
    :hook ((text-mode         . olivetti-mode)
           (prog-mode         . olivetti-mode)
           (Info-mode         . olivetti-mode)
           (org-mode          . olivetti-mode)
           (nov-mode          . olivetti-mode)
           (markdown-mode     . olivetti-mode)
           (mu4e-view-mode    . olivetti-mode)
           (elfeed-show-mode  . olivetti-mode)
           (mu4e-compose-mode . olivetti-mode))
    :custom
    (olivetti-body-width 80)
    :delight " ⊗"
    :config
    (olivetti-mode t)
    ) ; Ⓐ ⊛

(use-package gruvbox-theme
  ;; :config
  ;; (load-theme 'gruvbox-dark-soft :no-confirm)
  )
(use-package doom-themes
  :init (load-theme 'doom-dracula t))

(use-package dashboard
  :bind (:map dashboard-mode-map
              ;; ("j" . nil)
              ;; ("k" . nil)
              ;; ("n" . 'dashboard-next-line)
              ;; ("p" . 'dashboard-previous-line)
              )
  :init
  (add-hook 'dashboard-mode-hook (lambda () (setq show-trailing-whitespace nil)))
  (hl-line-mode t)
  (global-hl-line-mode t)
  :custom-face
  (dashboard-heading ((t (:foreground nil :weight bold)))) ; "#f1fa8c"
  :custom
  (dashboard-set-navigator t)
  (dashboard-center-content t)
  (dashboard-set-file-icons t)
  (dashboard-set-heading-icons t)
  (dashboard-display-icons-p t)
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
   dashboard-items '(
                     (agenda         . 7)
                     (recents        . 5)
                     (projects       . 2)
                     (bookmarks      . 5)
                     (registers      . 5)))
  (setq dashboard-agenda-sort-strategy '(todo-state-up time-up))
  )
;; (add-hook 'after-make-frame-functions
;;           (lambda (frame)
;;             (when (display-graphic-p frame)
;;               (with-selected-frame frame
;;                 (dashboard-refresh-buffer)))))
;; (add-hook 'after-make-frame-functions
;;           (lambda (frame)
;;             (with-selected-frame frame
;;               (load-theme 'your-theme t))))
(add-hook 'server-after-make-frame-hook
          (lambda ()
            (dashboard-refresh-buffer)))

(use-package all-the-icons
  :ensure t)
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom
  ;; Don't compact font caches during GC. Windows Laggy Issue
  (inhibit-compacting-font-caches t)
  (doom-modeline-height 15)
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
   org-pretty-entities t)

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

(defun isamert/toggle-side-bullet-org-buffer ()
  "Toggle `bullet.org` in a side buffer for quick note taking.  The buffer is opened in side window so it can't be accidentaly removed."
  (interactive)
  (isamert/toggle-side-buffer-with-file "~/bullet.org"))

(defun isamert/buffer-visible-p (buffer)
  "Check if given BUFFER is visible or not.  BUFFER is a string representing the buffer name."
  (or (eq buffer (window-buffer (selected-window))) (get-buffer-window buffer)))

(defun isamert/display-buffer-in-side-window (buffer)
  "Just like `display-buffer-in-side-window' but only takes a BUFFER and rest of the parameters are for my taste."
  (select-window
   (display-buffer-in-side-window
    buffer
    (list (cons 'side 'right)
          (cons 'slot 0)
          (cons 'window-width 84)
          (cons 'window-parameters (list (cons 'no-delete-other-windows t)
                                         (cons 'no-other-window nil)))))))

(defun isamert/remove-window-with-buffer (the-buffer-name)
  "Remove window containing given THE-BUFFER-NAME."
  (mapc (lambda (window)
          (when (string-equal (buffer-name (window-buffer window)) the-buffer-name)
            (delete-window window)))
        (window-list (selected-frame))))

(defun isamert/toggle-side-buffer-with-file (file-path)
  "Toggle FILE-PATH in a side buffer. The buffer is opened in side window so it can't be accidentaly removed."
  (interactive)
  (let ((fname (file-name-nondirectory file-path)))
    (if (isamert/buffer-visible-p fname)
	(isamert/remove-window-with-buffer fname)
      (isamert/display-buffer-in-side-window
       (save-window-excursion
	 (find-file file-path)
	 (current-buffer))))))

(defun my/org-roam-filter-by-tag (tag-name)
  (lambda (node)
    (member tag-name (org-roam-node-tags node))))

(defun my/org-roam-find-project ()
  (interactive)
  ;; Select a project file to open, creating it if necessary
  (org-roam-node-find nil nil
		      (my/org-roam-filter-by-tag "projects")))

(defun my/org-roam-find-students ()
  (interactive)
  ;; Select a project file to open, creating it if necessary
  (org-roam-node-find nil nil
		      (my/org-roam-filter-by-tag "students")))

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
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
              ("<tab>" . company-complete-selection))
  (:map lsp-mode-map
        ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package yasnippet
  :ensure t
  :config
  (yas-reload-all)
  (setq yas-snippet-dirs '("~/.emacs.d/snippets"))
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode)
  (yas-global-mode 1))

(use-package ivy
  :diminish
  :bind (
	 ("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1)
  )

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :config
  (counsel-mode 1)
  (evil-define-key 'normal 'global (kbd "<leader>bl") 'counsel-switch-buffer)
  )

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

(use-package general
  :config
  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (rune/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))

(use-package magit
  :config
  (setq
   magit-push-always-verify nil
   git-commit-summary-max-length 50
   )
  :bind ("C-x g" . magit-status)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

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

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(defun efs/lsp-mode-setup ()
        (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
        (lsp-headerline-breadcrumb-mode))

      (use-package lsp-mode
        :commands (lsp lsp-deferred)
        :hook (lsp-mode . efs/lsp-mode-setup)
        :init
        (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
        :config
        (lsp-enable-which-key-integration t))
    (use-package lsp-ui
      :hook (lsp-mode . lsp-ui-mode)
      :custom
      (lsp-ui-doc-position 'bottom))
  (use-package lsp-treemacs
    :after lsp)
(use-package lsp-ivy)

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/Projects/Code")
    (setq projectile-project-search-path '("~/Projects/Code")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq
   which-key-idle-delay 1
   )
 )

(use-package fancy-battery
  :config
  (setq fancy-battery-show-percentage t)
  (setq battery-update-interval 15)
  (if window-system
      (fancy-battery-mode)
    (display-battery-mode)))

(use-package dirvish
  :config
  (dirvish-override-dired-mode)
  )

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
  :hook (prog-mode . rainbow-delimiters-mode)
  )

(global-visual-line-mode t)
(save-place-mode t)
(global-auto-revert-mode t)
(display-line-numbers-mode t)
(recentf-mode t)
(savehist-mode t)

(add-to-list 'load-path "~/.config/emacs/writegood.el")
(load-file "~/.config/emacs/writegood.el")
(require 'writegood-mode)

(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'")
