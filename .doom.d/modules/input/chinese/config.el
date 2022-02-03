;;; input/chinese/config.el -*- lexical-binding: t; -*-


(use-package! pangu-spacing
  :hook (text-mode . pangu-spacing-mode)
  :config
  ;; Always insert `real' space in org-mode.
  (setq-hook! 'org-mode-hook pangu-spacing-real-insert-separtor t))

(use-package! rime
  :custom
  (default-input-method "rime")
  :bind (("M-n" . 'rime-force-enable))
  :config
  (setq rime-disable-predicates
        '(rime-predicate-evil-mode-p
          rime-predicate-after-alphabet-char-p
          rime-predicate-prog-in-code-p
          rime-predicate-space-after-cc-p
          ;; rime-predicate-after-ascii-char-p
          ;; rime-predicate-space-after-ascii-p
          rime-predicate-tex-math-or-command-p
          rime-predicate-punctuation-line-begin-p
          rime-predicate-punctuation-after-space-cc-p
          rime-predicate-punctuation-after-ascii-p
          rime-predicate-current-uppercase-letter-p))
  (setq rime-user-data-dir "~/.local/share/fcitx5/rime/")
  (setq rime-translate-keybindings
        '("C-`" "C-<grave>" "<left>" "<right>" "<up>" "<down>" "<prior>" "<next>" "<delete>"))
  (setq rime-show-candidate 'posframe))

(defun youdao-dictionary-search-and-voice-at-point-posframe ()
  (interactive)
  (youdao-dictionary-play-voice-at-point)
  (youdao-dictionary-search-at-point-posframe))

(use-package! youdao-dictionary
  :config
  (map! :map help-map
   (:prefix ("y" . "Youdao dict")
    :desc "Search at point" "y" #'youdao-dictionary-search-and-voice-at-point-posframe
    :desc "Voice at point" "v" #'youdao-dictionary-play-voice-at-point
    :desc "Search input" "i" #'youdao-dictionary-search-from-input)))


;;
;;; Hacks

(defadvice! +chinese--org-html-paragraph-a (args)
  "Join consecutive Chinese lines into a single long line without unwanted space
when exporting org-mode to html."
  :filter-args #'org-html-paragraph
  (cl-destructuring-bind (paragraph contents info) args
    (let* ((fix-regexp "[[:multibyte:]]")
           (fixed-contents
            (replace-regexp-in-string
             (concat "\\(" fix-regexp "\\) *\n *\\(" fix-regexp "\\)")
             "\\1\\2"
             contents)))
      (list paragraph fixed-contents info))))
