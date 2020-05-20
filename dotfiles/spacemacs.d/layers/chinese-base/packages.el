;;; packages.el --- chinese-base layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author: mslxl <mslxl@mslxl-PC>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Code:

(defconst chinese-base-packages
  '(posframe
    ;; pyim
    ;; pyim-basedict
    rime
    youdao-dictionary))

(defun chinese-base/init-youdao-dictionary ()
  (use-package youdao-dictionary
    :defer t
    :init
    (spacemacs/set-leader-keys "oy" 'youdao-dictionary-search-at-point+)
    ))

(defun chinese-base/init-posframe ()
  (use-package posframe
    :defer t
    :init))

(defun chinese-base/init-rime ()
  (use-package rime
    :defer t
    :config
    :custom
    (default-input-method "rime")
    :init
    (setq rime-show-candidate 'posframe)
    (setq rime-user-data-dir "~/.config/fcitx/rime")
    (spacemacs/set-leader-keys "oc" 'toggle-input-method)
    ))

;; (defun chinese-base/init-pyim-basedict ()
;;   (use-package pyim-basedict
;;     :defer t
;;     :init
;;     ))

;; (defun chinese-base/init-pyim ()
;;   (use-package pyim
;;     :defer t
;;     :ensure nil
;;     :demand t
;;     :config
;;     :init
;;     (use-package pyim-basedict
;;       :ensure nil
;;       :config (pyim-basedict-enable))
;;     (setq default-input-method "pyim")
;;     ;; (setq pyim-default-scheme 'quanpin)
;;     (setq pyim-default-scheme 'xiaohe-shuangpin)

;;      (setq-default pyim-english-input-switch-functions
;;                    '(pyim-probe-dynamic-english
;;                      pyim-probe-isearch-mode
;;                      pyim-probe-program-mode
;;                      pyim-probe-org-structure-template))
;;     (setq-default pyim-punctuation-half-width-functions
;;                   '(pyim-probe-punctuation-line-beginning))

;;     (pyim-isearch-mode 1)
;;     (setq pyim-page-tooltip 'posframe)
;;     (setq pyim-page-length 5)

;;     (spacemacs/set-leader-keys "oC" 'toggle-input-method)
;;     (spacemacs/set-leader-keys "oc" 'pyim-convert-string-at-point)
;;       ))
;;; packages.el ends here
