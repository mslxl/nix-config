(use-package! graphviz-dot-mode
  ;; :ensure t
  :config
  (setq graphviz-dot-indent-width 2))

(use-package! company-graphviz-dot)

(use-package! org-mind-map
  :init
  (require 'ox-org)
  :ensure t
  ;; Uncomment the below if 'ensure-system-packages` is installed
  ;;:ensure-system-package (gvgen . graphviz)
  :config
  (map! :map org-mode-map
      :localleader
      (:prefix ("m" . "mindmap writer")
       :desc "Whole file" "m" #'org-mind-map-write
       :desc "Current tree" "t" #'org-mind-map-write-current-tree
       :desc "Current branch" "b" #'org-mind-map-write-current-branch))

  (setq org-mind-map-engine "dot")       ; Default. Directed Graph
  ;; (setq org-mind-map-engine "neato")  ; Undirected Spring Graph
  ;; (setq org-mind-map-engine "twopi")  ; Radial Layout
  ;; (setq org-mind-map-engine "fdp")    ; Undirected Spring Force-Directed
  ;; (setq org-mind-map-engine "sfdp")   ; Multiscale version of fdp for the layout of large graphs
  ;; (setq org-mind-map-engine "twopi")  ; Radial layouts
  ;; (setq org-mind-map-engine "circo")  ; Circular Layout
 )
