;;org-export latex
(require 'ox-latex)

(setq org-latex-pdf-process
	'("xelatex -interaction nonstopmode %f"
	  "bibtex %b"
	  "xelatex -interaction nonstopmode %f"
	  "xelatex -interaction nonstopmode %f"
	  "rm -fr %b.out %b.log %b.tex %b.brf %b.bbl auto"
	  ))
(setq org-latex-compiler "xelatex")

(add-to-list 'org-latex-packages-alist '("" "listings"))
(setq org-latex-listings 'listings)

(add-to-list 'org-latex-classes
       '("org-ctex"
"\\documentclass[a4paper,titlepage]{ctexart}
\\usepackage{ctex}
\\usepackage{hyperref}
\\usepackage{ctexcap}
\\usepackage[a4paper,left=2cm,right=2cm,top=2cm,bottom=2cm]{geometry}
\\usepackage[T1]{fontenc}
\\usepackage{textcomp}
\\usepackage{babel}
\\usepackage{amsmath, amssymb}
\\usepackage{fancyhdr}
\\usepackage{import}
\\usepackage{cite}
\\usepackage{xifthen}
\\usepackage{pdfpages}
\\usepackage{transparent}
\\usepackage{graphicx}
\\usepackage{float}
\\usepackage{listings}
\\hypersetup{hidelinks,}
[NO-DEFAULT-PACKAGES]
[NO-PACKAGES]
[EXTRA]"
                ("\\section{%s}" . "\\section*{%s}")
                ("\\subsection{%s}" . "\\subsection*{%s}")
                ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                ("\\paragraph{%s}" . "\\paragraph*{%s}")
                ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
