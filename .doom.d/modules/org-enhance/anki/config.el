
(use-package! org-anki
  :config
  (customize-set-variable 'org-anki-default-deck "Default")

  (when (getenv "WIN_IP") ;; for wsl user
    (customize-set-variable 'org-anki-ankiconnnect-listen-address (concat "http://" (getenv "WIN_IP") ":8765")))

  (map! :map org-mode-map
      :localleader
      (:prefix ("w" . "anki sync")
       :desc "Sync all notes " "s" #'org-anki-sync-all
       :desc "Update all notes" "u" #'org-anki-update-all
       :desc "Sync current entry" "w" #'org-anki-sync-entry
       :desc "Make Cloze" "c" #'org-anki-cloze-dwim)))
