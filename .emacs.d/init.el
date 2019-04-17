(setq gdb-many-windows t)
;;; 変数の上にマウスカーソルを置くと値を表示
(add-hook 'gdb-mode-hook '(lambda () (gud-tooltip-mode t)))

(set-frame-font "Ricty Diminished-15")
(set-fontset-font
    nil 'japanese-jisx0208
    (font-spec :family "Ricty Diminished"))

;; global key bindings
(global-set-key "\C-h" 'delete-backward-char)
(global-set-key "\C-cc" 'compile)

;; set default theme
(load-theme 'deeper-blue t)

;; user's emacs lisp
(add-to-list 'load-path "~/elisp")

;; disable tool bar
(tool-bar-mode nil)

;; trying ipython tab completion: that works :)
(setq
 python-shell-interpreter "ipython"
 python-shell-interpreter-args ""
 python-shell-prompt-regexp "In \\[[0-9]+\\]: "
 python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
 python-shell-completion-setup-code "from IPython.core.completerlib import module_completion"
  python-shell-completion-module-string-code "';'.join(module_completion('''%s'''))\n"
  python-shell-completion-string-code "';'.join(get_ipython().Completer.all_completions('''%s'''))\n"
     )

;; ipython-mode
;(setq python-shell-interpreter "ipython")
;      python-shell-interpreter-args "-i")
;(require 'ipython nil t)

(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region (point-min) (point-max))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

;; package settings
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Standard Jedi.el setting
;(add-hook 'python-mode-hook 'jedi:setup)
;(setq jedi:complete-on-dot t)

;; flycheck
;;(add-hook 'after-init-hook #'global-flycheck-mode)
;;(setq flycheck-flake8-maximum-line-length 128)
;;(add-hook 'c-mode-common-hook 'flycheck-mode)

;; autopep8
;(require 'py-autopep8)
;(define-key python-mode-map (kbd "C-c F") 'py-autopep8)          ; バッファ全体のコード整形
;(define-key python-mode-map (kbd "C-c f") 'py-autopep8-region)   ; 選択リジョン内のコード整形
;;(add-hook 'python-mode-hook 'py-autopep8-enable-on-save)
;;(setq py-autopep8-options '("--max-line-length=128"))

(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; mozc setting
(when (require 'mozc nil t)
  (setq default-input-method "japanese-mozc"))

;; 変換/無変換キーで on/off
;; (global-set-key [henkan] 'toggle-input-method)
;; (defadvice mozc-handle-event (around intercept-keys (event))
;;   "Intercept keys muhenkan and zenkaku-hankaku, before passing keys
;; to mozc-server (which the function mozc-handle-event does), to
;; properly disable mozc-mode."
;;   (if (member event (list 'zenkaku-hankaku 'muhenkan))
;;       (progn
;; 	(mozc-clean-up-session)
;; 	(toggle-input-method))
;;     (progn ;(message "%s" event) ;debug
;;       ad-do-it)))
;; (ad-activate 'mozc-handle-event)

;; C and C++ mode
;;(add-hook 'c-mode-common-hook
;;          '(lambda ()
;;             (c-set-style "cc-mode")
;;             (gtags-mode 1)))

(add-hook 'c++-mode-common-hook
          '(lambda ()
             (c-set-style "cc-mode")
             (gtags-mode 1)))

(add-hook 'c-mode-common-hook
          '(lambda ()
             (gtags-mode 1)
	     (c-set-offset 'inextern-lang 0)))

(defvar cproto-program "cproto") 
(defun cproto-header (base-name) 
  (format "#ifndef _%s_H\n#define _%s_H\n\n" base-name base-name))
(defun cproto-footer (base-name) 
  "\n\n#endif") 

(defun cproto () 
  (interactive) 
  (string-match "\\([^/\\.]*\\)\\." buffer-file-name) 
  (let ((base-name (match-string 1 buffer-file-name))
        (cproto-args (list (concat "-I" (expand-file-name "../cobj"))
                           (concat "-I" (expand-file-name "../data"))
                           (concat "-I" (expand-file-name "../math"))
                           (concat "-I" (expand-file-name "../matrix2"))
                           (concat "-I" (expand-file-name "../vector2"))
                           (concat "-I" (expand-file-name "../trcl"))
                           (concat "-I" (expand-file-name "../robo"))
                           (concat "-I" (expand-file-name "../trml"))
                           (concat "-I" (expand-file-name ".."))
                           (concat "-Ic:/msys/1.0/local/include"))))
    ;;(insert (cproto-header (upcase base-name)))
    (let ((source (concat "../../src/" base-name ".c")))
      (apply 'call-process cproto-program nil '(t nil) nil source cproto-args)) 
    ;;(insert (cproto-footer (upcase base-name)))
    ))

;; (require 'cl)
;; (defun parallel-replace (plist &optional start end)
;;   (interactive
;;    `(,(loop with input = (read-from-minibuffer "Replace: ")
;;             with limit = (length input)
;;             for (item . index) = (read-from-string input 0)
;;                             then (read-from-string input index)
;;             collect (prin1-to-string item t) until (<= limit index))
;;      ,@(if (use-region-p) `(,(region-beginning) ,(region-end)))))
;;   (let* ((alist (loop for (key val . tail) on plist by #'cddr
;;                       collect (cons key val)))
;;          (matcher (regexp-opt (mapcar #'car alist) 'words)))
;;     (save-excursion
;;       (goto-char (or start (point)))
;;       (while (re-search-forward matcher (or end (point-max)) t)
;;         (replace-match (cdr (assoc-string (match-string 0) alist)))))))
;;(require 'parallel-replace)

;; ROS emacs(Indigo+)
(add-to-list 'load-path "/opt/ros/kinetic/share/emacs/site-lisp")
(add-to-list 'load-path "/opt/ros/jade/share/emacs/site-lisp")
(add-to-list 'load-path "/opt/ros/indigo/share/emacs/site-lisp")
(require 'rosemacs-config)

;; ROS emacs(Hydro)
(when (require 'rosemacs nil t)
  (invoke-rosemacs)
  (global-set-key "\C-x\C-r" ros-keymap))

(defun ROS-c-mode-hook()
  (setq c-basic-offset 2)
  (setq indent-tabs-mode nil)
  (c-set-offset 'substatement-open 0)
  (c-set-offset 'innamespace 0)
  (c-set-offset 'case-label '+))
(add-hook 'c-mode-common-hook 'ROS-c-mode-hook)
(add-hook 'c++-mode-hook 'ROS-c-mode-hook)
(add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))

;; Magit (git client for emacs)
(require 'magit nil t)
  
;; Cython mode
(require 'cython-mode nil t)
(add-to-list 'auto-mode-alist '("\\.pyx\\'" . cython-mode))

;; catkin build
(if (getenv "CATKIN_WORKSPACE")
    (setq compile-command "catkin build"))

;; Octave mode
(require 'ocrave-mode nil t)
(add-to-list 'auto-mode-alist '("\\.m\\'" . octave-mode))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(scroll-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'srefactor nil t)
(require 'srefactor-lisp nil t)

;; OPTIONAL: ADD IT ONLY IF YOU USE C/C++. 
;(semantic-mode 1) ;; -> this is optional for Lisp

;(define-key c-mode-map (kbd "M-RET") 'srefactor-refactor-at-point)
;(define-key c++-mode-map (kbd "M-RET") 'srefactor-refactor-at-point)
;(global-set-key (kbd "M-RET o") 'srefactor-lisp-one-line)
;(global-set-key (kbd "M-RET m") 'srefactor-lisp-format-sexp)
;(global-set-key (kbd "M-RET d") 'srefactor-lisp-format-defun)
;(global-set-key (kbd "M-RET b") 'srefactor-lisp-format-buffer)


;; CEDET
;; (require 'cedet)
;; (global-ede-mode t)

(defun my-semantic-hook ()
  (semantic-add-system-include
   (expand-file-name "~/Codes/ros/tarp4_ws/src/tarp4/include" 'c-mode)))
(add-hook 'semantic-init-hooks 'my-semantic-hook)

;; Automatically formats C code with GNU indent
(defun c-auto-format ()
  "Automatically formats C code with GNU indent"
  (interactive)
  (when (find major-mode '(c-mode c++-mode))
    (shell-command
     (format "indent %s" (shell-quote-argument (buffer-file-name))))
    (revert-buffer t t t)))

;;(add-hook 'after-save-hook 'c-auto-format)


;; function-args (altanative to CEDET)
;; (require 'function-args)
;; (fa-config-default)

;; (define-key function-args-mode-map (kbd "M-o") nil)
;; (define-key c-mode-map (kbd "C-M-:") 'moo-complete)
;; (define-key c++-mode-map (kbd "C-M-:") 'moo-complete)

;(require 'auto-complete)
(when (require 'auto-complete-config nil t)
  (global-auto-complete-mode t)
  (setq-default ac-sources '(ac-source-semantic-raw))
  )

;; Emacs起動時にrst.elを読み込み
(require 'rst)
;; 拡張子の*.rst, *.restのファイルをrst-modeで開く
(setq auto-mode-alist
      (append '(("\\.rst$" . rst-mode)
		("\\.rest$" . rst-mode)) auto-mode-alist))
;; 背景が黒い場合はこうしないと見出しが見づらい
(setq frame-background-mode 'dark)
;; 全部スペースでインデントしましょう
(add-hook 'rst-mode-hook '(lambda() (setq indent-tabs-mode nil)))
