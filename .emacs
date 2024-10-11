(org-babel-load-file
 (expand-file-name
  "~/.config/emacs/config.org"
  user-emacs-directory))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("d77d6ba33442dd3121b44e20af28f1fae8eeda413b2c3d3b9f1315fbda021992" default))
 '(doom-modeline-check-simple-format t nil nil "Customized with use-package doom-modeline")
 '(org-safe-remote-resources '("\\`https://fniessen\\.github\\.io\\(?:/\\|\\'\\)"))
 '(package-selected-packages
   '(typst-mode ox-typst org-make-toc gruvbox-theme cycle-themes catppuccin-theme modus-themes org-modern ligature dashboard minions doom-modeline doom-themes olivetti nerd-icons org-download org-re-reveal evil-numbers evil-surround evil-commentary evil rainbow-delimiters rainbow-mode highlight-numbers volatile-highlights highlight-indent-guides fancy-battery flycheck-popup-tip flycheck which-key git-timemachine git-gutter-fringe git-gutter magit yasnippet company corfu persistent-scratch))
 '(safe-local-variable-values '((org-re-reveal-progress . true))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
