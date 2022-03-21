;;org-export latex
(require 'ox-latex)

(setq org-latex-pdf-process
      '("xelatex --shell-escape -interaction nonstopmode %f"
	"bibtex %b"
	"xelatex --shell-escape -interaction nonstopmode %f"
	"xelatex --shell-escape -interaction nonstopmode %f"
	"rm -fr %b.out %b.log %b.tex %b.brf %b.bbl auto"
	))

(setq org-latex-compiler "xelatex")

(setq org-latex-listings 'minted) ;; Use highlight by minted

(setq org-latex-minted-options
      '(("frame" "single")
        ("linenos" "true")
        ("fontsize" "\\scriptsize")
        ("mathescape" "true")))

(add-to-list 'org-latex-classes
             '("org-ctex"
               "\\documentclass[a4paper,titlepage]{ctexart}
\\usepackage[a4paper,left=2cm,right=2cm,top=2cm,bottom=2cm]{geometry}
\\usepackage[T1]{fontenc}
\\usepackage{textcomp}
\\usepackage{babel}
\\usepackage{fancyhdr}
\\usepackage{import}
\\usepackage{cite}
\\usepackage{xifthen}
\\usepackage{pdfpages}
\\usepackage{transparent}
\\usepackage[cache=false]{minted}
\\usepackage{float}
[EXTRA]"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))


(setq-default TeX-engine 'xetex)
(setq-default TeX-PDF-mode t)
(add-hook 'TeX-mode-hook
          (lambda ()
            (setq TeX-command-extra-options "-shell-escape")))


;; (add-hook 'TeX-mode-hook
;;           (lambda ()
;;             (setq yas-buffer-local-condition
;;                   '(if (texmathp)
;;                        '(require-snippet-condition . auto)
;;                      t))))

 (defun my-yas-try-expanding-auto-snippets ()
    (when (and (boundp 'yas-minor-mode) yas-minor-mode)
      (let ((yas-buffer-local-condition ''(require-snippet-condition . auto)))
        (yas-expand))))
  (add-hook 'post-command-hook #'my-yas-try-expanding-auto-snippets)
