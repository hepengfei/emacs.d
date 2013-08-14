
;; 
;; 我的emacs配置文件，经过千锤百炼呀！
;; 


;; 
;; 显示设置
;; 

(scroll-bar-mode -1)               ; 不要scroll bar
(tool-bar-mode -1)                 ; 去掉工具栏
(column-number-mode t)             ; 显示列号
(menu-bar-mode -1)                 ; 去掉菜单栏
(ansi-color-for-comint-mode-on)    ; 支持ansi颜色
;;(global-linum-mode t)              ; 打开全局显示行号，开关:linum-mode

;; 颜色设置
(setq frame-background-mode 'dark)
(set-background-color   "black")
(set-border-color   "black")
;;(set-foreground-color   "gray90")
(set-foreground-color "Wheat")
(set-cursor-color   "yellow")

;; 颜色配置2 - 据说是保护色
;; ;; (setq frame-background-mode 'light)
;; (set-background-color   "#AFCD85")
;; (set-foreground-color   "black")
;; ;; (set-cursor-color   "darkgreen")
;; ;; (set-cursor-color   "seagreen")
;; (set-cursor-color   "forestgreen")

;; 高亮光标所在行设置
(require 'hl-line)
(global-hl-line-mode t)

(global-font-lock-mode 1)               ; 打开语法高亮
(transient-mark-mode 1)                 ; 使选中区域可见


;; 括号匹配时显示另外一边的括号，而不是烦人的跳到另一个括号。
(show-paren-mode t)
(setq show-paren-style 'parentheses)

;; 显示时间。
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(setq display-time-use-mail-icon t)
(setq display-time-interval 1)
(setq display-time-format "%m月%d日 %a %H:%M")
(display-time-mode 1)

(setq inhibit-startup-screen t)        ;去掉启动欢迎界面


(setq-default tab-width 4)             ; 设置tab宽度
(setq-default indent-tabs-mode nil)    ; 用空格替换tab
(setq mark-diary-entries-in-calendar t); 标记有日记的日期

;; dired模式的配置，可实现通过M-o隐藏不重要的文件。具体可参考[[info:Dired-X]]
(add-hook 'dired-load-hook
          (lambda ()
            (load "dired-x")
            ;; Set dired-x global variables here.
            (setq dired-omit-files (concat dired-omit-files "\\|^\\.\\|~$"))
            ))
(add-hook 'dired-mode-hook
          (lambda ()
            ;; Set dired-x buffer-local variables here.
            (dired-omit-mode 1)
            ))
;; 通过控制ls的参数来调整dired模式显示的内容
(setq dired-listing-switches "-alhgGD") ;去掉了用户和组信息，文件大小
                                        ;以可读显示，按时间排序


;; 安装说明：http://emacs-w3m.namazu.org/index-en.html
;; 要从下面取最新代码才能支持emacs-24及以上
;; cvs -d :pserver:anonymous:@cvs.namazu.org:/storage/cvsroot co emacs-w3m
;;(require 'w3m-load)

;; 
;; 操作设置
;; 

(add-to-list 'load-path
              "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas/global-mode 1)

(setq x-select-enable-clipboard t) ; 与系统剪贴版互通

;; C-x C-b 缺省的绑定很不好用，改成一个比较方便的 electric-buffer-list，执行
;; 之后：
;;     光标自动转到 Buffer List buffer 中；
;;     n, p   上下移动选择 buffer；
;;     S      保存改动的 buffer；
;;     D      删除 buffer。
(global-set-key "\C-x\C-b" 'electric-buffer-list)


(add-hook 'comint-output-filter-functions
          'comint-watch-for-password-prompt) ;隐藏口令字

(setq require-final-newline t) ; 存盘的时候，要求最后一个字符时换行符。
(setq bookmark-save-flag 1) ; 设置书签时及时保存到文件

;; 试一下新的扩展功能M+<space>，功能类似M-/
(global-set-key "\M- " 'hippie-expand)

;; 
;; 重定义hs-minor-mode的keybinding
;; hs-minor-mode的缺省键盘定义太复杂了。C-c @ 要来回换半天。
;; 下面的代码把它换成了'C-c h/s/M-h/M-s/l/c'
;;
;; 经长期使用，下面的设置比较适合我。
;; 
(defun my-hs-minor-mode-map-setup ()
  "为hs-minor-mode设置自己的绑定键"
  (define-key hs-minor-mode-map [?\C-c ?h] 'hs-hide-block)    ; C-c h
  (define-key hs-minor-mode-map [?\C-c ?s] 'hs-show-block)    ; C-c s
  (define-key hs-minor-mode-map [?\C-c ?\M-h] 'hs-hide-all)   ; C-c M-h
  (define-key hs-minor-mode-map [?\C-c ?\M-s] 'hs-show-all)   ; C-c M-s
  (define-key hs-minor-mode-map [?\C-c ?H] 'hs-hide-all)      ; C-c H
  (define-key hs-minor-mode-map [?\C-c ?S] 'hs-show-all)      ; C-c S
  (define-key hs-minor-mode-map [?\C-c ?l] 'hs-hide-level)    ; C-c l
  (define-key hs-minor-mode-map [?\C-c ?t] 'hs-toggle-hiding) ; C-c t
  )

;; 关联hs-minor模式
(add-hook 'hs-minor-mode-hook 'my-hs-minor-mode-map-setup t)

;; 将hs-minor模式与其它主要模式关联起来
(add-hook 'c-mode-hook 'hs-minor-mode)
(add-hook 'c++-mode-hook 'hs-minor-mode)
(add-hook 'java-mode-hook 'hs-minor-mode)


;; 把缺省的 major mode 设置为 text-mode
;; (setq default-major-mode 'text-mode)

;; croll-margin 3 可以在靠近屏幕边沿3行时就开始滚动，可以很好的看到上下文。
;; (setq scroll-step 1
;;       scroll-margin 3
;;       scroll-conservatively 10000)

;; 启用五笔输入法
(add-to-list 'load-path "~/.emacs.d/plugins/wubi")
(require 'wubi)
(wubi-load-local-phrases) ; add user's Wubi phrases
(register-input-method
 "chinese-wubi" "Chinese-GBK" 'quail-use-package
 "WuBi" "WuBi"
 "wubi")
;(set-language-environment 'Chinese-GB))
(setq default-input-method "chinese-wubi")


;; 
;; 字体设置
;; 
(if window-system
    (if (string= system-type "windows-nt")
        ;; windows下的配置
        (progn
          (set-frame-font "Consolas-14")
          ;;(set-frame-font "SimSun-12")
          ;;(set-frame-font "宋体-12")
          (set-fontset-font (frame-parameter nil 'font)  'han '("Microsoft YaHei" . "unicode-bmp"))
          (set-fontset-font (frame-parameter nil 'font)  'symbol '("Microsoft YaHei" . "unicode-bmp"))
          (set-fontset-font (frame-parameter nil 'font)  'cjk-misc '("Microsoft YaHei" . "unicode-bmp"))
          )

      ;; GNU/Linux下的配置
      (progn
        ;; (set-frame-font "文泉驿等宽正黑-14") ; Linux下的默认字体
        (set-frame-font "Consolas-13")  ; 13号字体能显示两列70个字符，如果显示器更大，则最好用14号字体
        (set-fontset-font (frame-parameter nil 'font)  'han '("Microsoft YaHei" . "unicode-bmp"))
        (set-fontset-font (frame-parameter nil 'font)  'symbol '("Microsoft YaHei" . "unicode-bmp"))
        (set-fontset-font (frame-parameter nil 'font)  'cjk-misc '("Microsoft YaHei" . "unicode-bmp"))
        )
      
      ))


(add-to-list 'load-path "~/.emacs.d/plugins")
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))

(require 'xcscope)
(define-key global-map [?\C-c ?c ?i] 'cscope-set-initial-directory)
(define-key global-map [?\C-c ?c ?I] 'cscope-unset-initial-directory)
(define-key global-map [?\C-c ?c ?b] 'cscope-index-files)
(define-key global-map [?\C-c ?c ?f] 'cscope-find-this-symbol)
(define-key global-map [?\C-c ?c ?F] 'cscope-find-global-definition)
(define-key global-map [?\C-c ?c ?g] 'cscope-find-global-definition-no-prompting)
(define-key global-map [?\C-c ?c ?m] 'cscope-pop-mark)
(define-key global-map [?\C-c ?c ?n] 'cscope-next-symbol)
(define-key global-map [?\C-c ?c ?N] 'cscope-next-file)
(define-key global-map [?\C-c ?c ?p] 'cscope-prev-symbol)
(define-key global-map [?\C-c ?c ?P] 'cscope-prev-file)
(define-key global-map [?\C-c ?c ?d] 'cscope-display-buffer)
(define-key global-map [?\C-c ?c ?A] 'cscope-display-buffer-toggle)
(define-key global-map [?\C-c ?c ?a] 'cscope-find-this-file)
(define-key global-map [?\C-c ?c ?e] 'cscope-find-egrep-pattern)
(define-key global-map [?\C-c ?c ?0] 'cscope-find-functions-calling-this-function)
(define-key global-map [?\C-c ?c ?c] 'cscope-find-called-functions)
(define-key global-map [?\C-c ?c ?t] 'cscope-find-this-text-string)
(define-key global-map [?\C-c ?c ?1] 'cscope-find-files-including-file)

;; (define-key global-map [(control f3)]  'cscope-set-initial-directory)
;; (define-key global-map [(control f4)]  'cscope-unset-initial-directory)
;; (define-key global-map [(control f5)]  'cscope-find-this-symbol)
;; (define-key global-map [(control f6)]  'cscope-find-global-definition)
;; (define-key global-map [(control f7)]
;;   'cscope-find-global-definition-no-prompting)
;; (define-key global-map [(control f8)]  'cscope-pop-mark)
;; (define-key global-map [(control f9)]  'cscope-next-symbol)
;; (define-key global-map [(control f10)] 'cscope-next-file)
;; (define-key global-map [(control f11)] 'cscope-prev-symbol)
;; (define-key global-map [(control f12)] 'cscope-prev-file)
;; (define-key global-map [(meta f9)]  'cscope-display-buffer)
;; (define-key global-map [(meta f10)] 'cscope-display-buffer-toggle)


;; c-set-style
(add-hook 'c-mode-hook
          '(lambda ()
             (c-set-style "linux")
             (setq-default c-basic-offset 4)    ;更改style中的tab宽度为4
             ))

;; c++-set-style
(add-hook 'c++-mode-hook
          '(lambda ()
             (c-set-style "linux")
             (setq-default c-basic-offset 4)    ;更改style中的tab宽度为4
             ))


;; 
;; Org-mode
;; 

;; The following lines are always needed.  Choose your own keys.
;;(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode)) ; 添加后缀关联
(global-set-key "\C-cl" 'org-store-link) ; 全局快捷键设置
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;; You can insert and follow links that have Org syntax not only in Org,
;; but in any Emacs buffer.  For this, you should create two global
;; commands, like this (please select suitable global keys yourself):
;; 详见：[[info:org:Using links outside Org]]
(global-set-key "\C-cL" 'org-insert-link-global)
(global-set-key "\C-co" 'org-open-at-point-global)


(setq org-log-done t)   ; 标记TODO项的完成时间
(setq org-hide-leading-stars t); only show one *
(setq org-startup-folded 'content); Best default for small files with tables: overview content showall

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "DELEGATE(g)" "|" "DONE(d)")
        (sequence "BUG(b)" "REPORT(r)" "|" "FIXED(f)")
        (sequence "|" "CANCELED(c)")))


;;启动LaTeX设置
;;(load "auctex.el" nil t t)
;;(load "preview-latex.el" nil t t)

;; 
;; PERSONAL and PRIVATE configuration
;; 

;; name and email
(setq user-full-name "贺鹏飞")
(setq user-mail-address "hepengfei@xunlei.com")

;; 默认的日记文件
(setq diary-file "~/Notebook/Diary")

;; org文件设置
(setq org-directory "~/Notebook/")
(setq org-agenda-files (list (concat org-directory "/Todos.org")))

(setq org-default-notes-file (concat org-directory "/Capture.org"))


;; 缺省书签文件的路径及文件名。
(setq bookmark-default-file "~/.emacs.d/bookmarks")

;; 缺省的定义缩写的文件。
(setq abbrev-file-name "~/.emacs.d/abbrevs")

;; email configuration

;; using smtpmail
;; [[info:smtpmail:Emacs Speaks SMTP]]

;; If you use the default mail user agent.
(setq send-mail-function 'smtpmail-send-it)
;; If you use Message or Gnus.
(setq message-send-mail-function 'smtpmail-send-it)
(setq smtpmail-smtp-server "mail.xunlei.com")
;; (setq smtpmail-smtp-service 25) ;587
;; (setq rmail-primary-inbox-list '("~/Mail/inbox"))

;; 设置默认的邮件头，通过FCC指定已发送的邮件放在哪里；多个头字段用\n分
;; 隔。参考[[info:Sending Mail:Mail Headers]]
(setq mail-default-headers
      (concat
       "Fcc: ~/Mail/sent-" (format-time-string "%Y%m" (current-time))
       ;; "\nXXX: xxx" ; 其它头字段
       ))

;; ;; Use STARTTLS without authentication against the server.
;; (setq smtpmail-starttls-credentials
;;       '(("HOSTNAME" "PORT" nil nil)))


;; emacs server
;;(server-force-delete)
;;(server-start)



;; CEDET
;;(global-ede-mode 1)                      ; Enable the Project management system
;;(semantic-load-enable-code-helpers)      ; Enable prototype help and smart completion 
;;(global-srecode-minor-mode 1)            ; Enable template insertion menu
;; (semantic-load-enable-minimum-features)
;; (semantic-load-enable-guady-code-helpers)
;; (semantic-load-enable-excessive-code-helpers)
;; (semantic-load-enable-semantic-debugging-helpers)


;; TAB and RET auto align and indent
;; (defun my-indent-or-complete ()
;;   (interactive)
;;   (if (looking-at "\\>")
;;       (hippie-expand nil)
;;     (indent-for-tab-command)))
;; (add-hook 'c-mode-common-hook
;;           (function (lambda ()
;;                       (define-key c-mode-base-map [(tab)] 'my-indent-or-complete)
;;                       (define-key c-mode-base-map [(control m)] 'align-newline-and-indent)
;;                       (c-toggle-auto-state))))



; Some initial langauges we want org-babel to support
(org-babel-do-load-languages
 'org-babel-load-languages
 '((sh . t)
   (python . t)
   (scheme . t)
   (emacs-lisp . t)
   (js . t)
   (awk . t)
   (ruby . t)
   (ditaa . t)
   (dot . t)
   (perl . t)
   ))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-theme-load-path (quote (custom-theme-directory t "~/.emacs.d/color-theme-solarized/")))
 '(org-export-language-setup (quote (("en" "Author" "Date" "Table of Contents" "Footnotes") ("zh-cn" "作者" "日期" "目录" "脚注"))))
)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; 仅在窗口模式下加载此主题；文本模式下不能用
(if window-system (load-theme 'solarized-dark t))

;; 可以使用C-c 前后方向键，undo/redo buffer的布局
(winner-mode)

;; 可以使用shift+方向键，进行buffer切换
(windmove-default-keybindings)

;; Local Variables:
;; mode: emacs-lisp
;; coding: utf-8
;; End:

